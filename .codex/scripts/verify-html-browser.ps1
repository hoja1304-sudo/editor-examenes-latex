param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$HtmlPath,

  [string[]]$Items = @(),

  [string]$OutputDir,

  [string]$BrowserPath,

  [int]$ViewportWidth = 1280,

  [int]$ViewportHeight = 900
)

$ErrorActionPreference = "Stop"

function Resolve-Browser {
  param([string]$RequestedPath)

  if ($RequestedPath) {
    if (Test-Path -LiteralPath $RequestedPath) {
      return (Resolve-Path -LiteralPath $RequestedPath).Path
    }
    throw "No se encontro el navegador indicado: $RequestedPath"
  }

  $candidates = @(
    (Join-Path $env:ProgramFiles "Google\Chrome\Application\chrome.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "Google\Chrome\Application\chrome.exe"),
    (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe"),
    (Join-Path $env:ProgramFiles "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "Microsoft\Edge\Application\msedge.exe"),
    (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\Application\msedge.exe")
  )

  foreach ($candidate in $candidates) {
    if ($candidate -and (Test-Path -LiteralPath $candidate)) {
      return (Resolve-Path -LiteralPath $candidate).Path
    }
  }

  throw "No se encontro Chrome ni Edge. Instale uno de ellos o use -BrowserPath."
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
  throw "No se encontro Node.js en PATH."
}

$resolvedHtml = (Resolve-Path -LiteralPath $HtmlPath).Path
$browserExe = Resolve-Browser -RequestedPath $BrowserPath

$itemNumbers = @()
foreach ($rawItem in @($Items)) {
  foreach ($part in ([string]$rawItem -split ",")) {
    $trimmed = $part.Trim()
    if (-not $trimmed) { continue }
    $itemNumbers += [int]$trimmed
  }
}

if (-not $OutputDir) {
  $baseName = [IO.Path]::GetFileNameWithoutExtension($resolvedHtml)
  $OutputDir = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..\..")) ".codex\tmp\browser-html\$baseName"
}
$resolvedOutputDir = if ([IO.Path]::IsPathRooted($OutputDir)) {
  $OutputDir
} else {
  Join-Path (Resolve-Path ".") $OutputDir
}
New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null

$runnerPath = Join-Path $env:TEMP ("codex-html-browser-verify-{0}.js" -f ([guid]::NewGuid().ToString("N")))

$runner = @'
const fs = require("fs");
const http = require("http");
const net = require("net");
const path = require("path");
const { spawn } = require("child_process");
const { pathToFileURL } = require("url");

const config = JSON.parse(process.env.CODEX_BROWSER_VERIFY_CONFIG);

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function freePort() {
  return new Promise((resolve, reject) => {
    const srv = net.createServer();
    srv.on("error", reject);
    srv.listen(0, "127.0.0.1", () => {
      const port = srv.address().port;
      srv.close(() => resolve(port));
    });
  });
}

function getJson(url) {
  return new Promise((resolve, reject) => {
    const req = http.get(url, res => {
      let data = "";
      res.setEncoding("utf8");
      res.on("data", chunk => data += chunk);
      res.on("end", () => {
        try {
          resolve(JSON.parse(data));
        } catch (err) {
          reject(err);
        }
      });
    });
    req.on("error", reject);
  });
}

function putJson(url) {
  return new Promise((resolve, reject) => {
    const req = http.request(url, { method: "PUT" }, res => {
      let data = "";
      res.setEncoding("utf8");
      res.on("data", chunk => data += chunk);
      res.on("end", () => {
        try {
          resolve(JSON.parse(data));
        } catch (err) {
          reject(err);
        }
      });
    });
    req.on("error", reject);
    req.end();
  });
}

async function waitForEndpoint(port, tries = 80) {
  for (let i = 0; i < tries; i++) {
    try {
      await getJson(`http://127.0.0.1:${port}/json/version`);
      return;
    } catch {
      await delay(100);
    }
  }
  throw new Error("El navegador no abrio el puerto de depuracion.");
}

function connectCdp(wsUrl, diagnostics) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(wsUrl);
    let seq = 0;
    const pending = new Map();
    ws.onopen = () => resolve({
      send(method, params = {}) {
        const id = ++seq;
        ws.send(JSON.stringify({ id, method, params }));
        return new Promise((res, rej) => pending.set(id, { res, rej, method }));
      },
      close() {
        ws.close();
      }
    });
    ws.onerror = err => reject(err);
    ws.onmessage = event => {
      const msg = JSON.parse(event.data);
      if (msg.id && pending.has(msg.id)) {
        const item = pending.get(msg.id);
        pending.delete(msg.id);
        if (msg.error) {
          item.rej(new Error(`${item.method}: ${msg.error.message}`));
        } else {
          item.res(msg.result);
        }
        return;
      }
      if (msg.method === "Runtime.exceptionThrown") {
        diagnostics.errors.push(msg.params.exceptionDetails.text || "Runtime exception");
      }
      if (msg.method === "Runtime.consoleAPICalled" && msg.params.type === "error") {
        const text = (msg.params.args || []).map(a => a.value || a.description || "").join(" ");
        diagnostics.errors.push(text || "console.error");
      }
      if (msg.method === "Log.entryAdded" && msg.params.entry && msg.params.entry.level === "error") {
        diagnostics.errors.push(msg.params.entry.text || "log error");
      }
    };
  });
}

async function main() {
  fs.mkdirSync(config.outputDir, { recursive: true });
  const port = await freePort();
  const userDataDir = path.join(config.outputDir, "browser-profile");
  fs.mkdirSync(userDataDir, { recursive: true });

  const browserArgs = [
    "--headless=new",
    "--disable-gpu",
    "--no-first-run",
    "--no-default-browser-check",
    "--allow-file-access-from-files",
    `--remote-debugging-port=${port}`,
    `--user-data-dir=${userDataDir}`,
    "about:blank"
  ];
  const browser = spawn(config.browserPath, browserArgs, { stdio: ["ignore", "pipe", "pipe"] });
  let stderr = "";
  browser.stderr.on("data", d => stderr += d.toString());

  try {
    await waitForEndpoint(port);
    const target = await putJson(`http://127.0.0.1:${port}/json/new?${encodeURIComponent(pathToFileURL(config.htmlPath).href)}`);
    const diagnostics = { errors: [] };
    const cdp = await connectCdp(target.webSocketDebuggerUrl, diagnostics);

    await cdp.send("Page.enable");
    await cdp.send("Runtime.enable");
    await cdp.send("Log.enable");
    await cdp.send("Emulation.setDeviceMetricsOverride", {
      width: config.viewportWidth,
      height: config.viewportHeight,
      deviceScaleFactor: 1,
      mobile: false
    });
    await cdp.send("Page.navigate", { url: pathToFileURL(config.htmlPath).href });
    await delay(700);

    const itemCountResult = await cdp.send("Runtime.evaluate", {
      expression: "typeof ITEMS !== 'undefined' ? ITEMS.length : -1",
      returnByValue: true
    });
    const itemCount = itemCountResult.result.value;

    await cdp.send("Runtime.evaluate", {
      expression: "document.querySelector('#inicio button').click()",
      returnByValue: true
    });
    await delay(250);

    const captured = [];
    for (const item of config.items) {
      if (item < 1 || item > itemCount) {
        diagnostics.errors.push(`Item fuera de rango: ${item}`);
        continue;
      }
      await cdp.send("Runtime.evaluate", {
        expression: `show(${item - 1}); window.scrollTo(0, 0);`,
        returnByValue: true
      });
      await delay(250);
      const shot = await cdp.send("Page.captureScreenshot", {
        format: "png",
        captureBeyondViewport: true
      });
      const out = path.join(config.outputDir, `item-${String(item).padStart(2, "0")}.png`);
      fs.writeFileSync(out, Buffer.from(shot.data, "base64"));
      captured.push(out);
    }

    const summary = {
      htmlPath: config.htmlPath,
      browserPath: config.browserPath,
      itemCount,
      screenshots: captured,
      errors: diagnostics.errors
    };
    const summaryPath = path.join(config.outputDir, "summary.json");
    fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2), "utf8");
    console.log(JSON.stringify(summary, null, 2));
    cdp.close();

    if (diagnostics.errors.length) {
      process.exitCode = 2;
    }
  } finally {
    browser.kill();
    if (stderr.trim()) {
      fs.writeFileSync(path.join(config.outputDir, "browser-stderr.log"), stderr, "utf8");
    }
  }
}

main().catch(err => {
  console.error(err && err.stack ? err.stack : err);
  process.exit(1);
});
'@

Set-Content -Path $runnerPath -Value $runner -Encoding UTF8

$config = @{
  htmlPath = $resolvedHtml
  outputDir = (Resolve-Path -LiteralPath $resolvedOutputDir).Path
  browserPath = $browserExe
  items = @($itemNumbers)
  viewportWidth = $ViewportWidth
  viewportHeight = $ViewportHeight
} | ConvertTo-Json -Compress

$env:CODEX_BROWSER_VERIFY_CONFIG = $config
try {
  & $node.Source $runnerPath
  exit $LASTEXITCODE
}
finally {
  Remove-Item -LiteralPath $runnerPath -Force -ErrorAction SilentlyContinue
  Remove-Item Env:\CODEX_BROWSER_VERIFY_CONFIG -ErrorAction SilentlyContinue
}
