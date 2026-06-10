<#
.SYNOPSIS
  Render TikZ/LaTeX figures from a .tex source into self-contained SVG files.

.DESCRIPTION
  This helper is intended for interactive HTML practices. It reuses the
  preamble of the source .tex file, compiles a temporary DVI with latex, and
  converts it to SVG with dvisvgm.

  Common examples:

    powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-svg.ps1 `
      "MiniPrueba_Afirmaciones_1_2_Secundaria_2026.tex" `
      -Macro itemunoB -OutputName itemunoB.svg

    powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-svg.ps1 `
      "MiniPrueba_Afirmaciones_1_2_Secundaria_2026.tex" `
      -Snippet "\itemunoA" -OutputName itemunoA.svg

    powershell -ExecutionPolicy Bypass -File .codex/scripts/render-tikz-svg.ps1 `
      "MiniPrueba_Afirmaciones_1_2_Secundaria_2026.tex" -AllTikz

  By default, text is converted to paths via dvisvgm --no-fonts so the SVG is
  visually stable inside an HTML file without external font dependencies.
#>

[CmdletBinding(DefaultParameterSetName = "Snippet")]
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$SourceTex,

  [Parameter(ParameterSetName = "Snippet", Mandatory = $true)]
  [string]$Snippet,

  [Parameter(ParameterSetName = "Macro", Mandatory = $true)]
  [string]$Macro,

  [Parameter(ParameterSetName = "AllTikz", Mandatory = $true)]
  [switch]$AllTikz,

  [string]$OutputDir,

  [string]$OutputName,

  [switch]$KeepText,

  [switch]$KeepTemp
)

$ErrorActionPreference = "Stop"

function Resolve-Tool {
  param([string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if (-not $cmd) {
    throw "Required tool '$Name' was not found in PATH."
  }
  return $cmd.Source
}

function Get-SafeName {
  param([string]$Name)
  $safe = $Name -replace "^[\\]+", ""
  $safe = $safe -replace "[^A-Za-z0-9_.-]+", "-"
  if ([string]::IsNullOrWhiteSpace($safe)) { return "figure" }
  return $safe
}

function Initialize-MiktexWorkspace {
  param([string]$WorkspaceRoot)

  $miktexRoot = Join-Path $WorkspaceRoot ".codex/miktex-user"
  $paths = @(
    (Join-Path $miktexRoot "config"),
    (Join-Path $miktexRoot "data"),
    (Join-Path $miktexRoot "install")
  )
  foreach ($p in $paths) {
    New-Item -ItemType Directory -Force -Path $p | Out-Null
  }

  $env:MIKTEX_USERCONFIG = $paths[0]
  $env:MIKTEX_USERDATA = $paths[1]
  $env:MIKTEX_USERINSTALL = $paths[2]

  $initexmf = Get-Command "initexmf" -ErrorAction SilentlyContinue
  if ($initexmf) {
    & $initexmf.Source --enable-installer | Out-Null
    & $initexmf.Source --set-config-value="[MPM]AutoInstall=1" | Out-Null
    & $initexmf.Source --default-paper-size=letter | Out-Null
  }
}

function Get-Preamble {
  param([string]$Tex)
  $marker = "\begin{document}"
  $idx = $Tex.IndexOf($marker)
  if ($idx -lt 0) {
    throw "Could not find \begin{document} in the source .tex file."
  }
  return $Tex.Substring(0, $idx)
}

function Invoke-Render {
  param(
    [string]$Preamble,
    [string]$Body,
    [string]$OutPath,
    [string]$TempRoot,
    [string]$LatexExe,
    [string]$DvisvgmExe,
    [bool]$KeepTextMode
  )

  $jobName = [IO.Path]::GetFileNameWithoutExtension($OutPath)
  $jobDir = Join-Path $TempRoot $jobName
  New-Item -ItemType Directory -Force -Path $jobDir | Out-Null

  $tmpTex = Join-Path $jobDir "figure.tex"
  $tmpDvi = Join-Path $jobDir "figure.dvi"
  $tmpSvg = Join-Path $jobDir "figure.svg"

  $doc = @"
$Preamble
\begin{document}
\pagestyle{empty}
\thispagestyle{empty}
\begin{center}
$Body
\end{center}
\end{document}
"@

  Set-Content -Path $tmpTex -Value $doc -Encoding UTF8

  & $LatexExe -interaction=nonstopmode -halt-on-error "-output-directory=$jobDir" $tmpTex | Out-Null
  if (-not (Test-Path -LiteralPath $tmpDvi)) {
    $log = Join-Path $jobDir "figure.log"
    if (Test-Path -LiteralPath $log) {
      Get-Content -Path $log -Tail 80 | Write-Host
    }
    throw "LaTeX did not produce a DVI file for '$jobName'."
  }

  $args = @("--exact", "--bbox=min", "--output=$tmpSvg")
  if (-not $KeepTextMode) {
    $args += "--no-fonts"
  }
  $args += $tmpDvi

  & $DvisvgmExe @args | Out-Null
  if (-not (Test-Path -LiteralPath $tmpSvg)) {
    throw "dvisvgm did not produce an SVG file for '$jobName'."
  }

  New-Item -ItemType Directory -Force -Path ([IO.Path]::GetDirectoryName($OutPath)) | Out-Null
  Copy-Item -LiteralPath $tmpSvg -Destination $OutPath -Force
  return $jobDir
}

$sourcePath = (Resolve-Path -LiteralPath $SourceTex).Path
$workspaceRoot = (Resolve-Path ".").Path
Initialize-MiktexWorkspace -WorkspaceRoot $workspaceRoot

$latexExe = Resolve-Tool "latex"
$dvisvgmExe = Resolve-Tool "dvisvgm"

if (-not $OutputDir) {
  $OutputDir = Join-Path ([IO.Path]::GetDirectoryName($sourcePath)) "svg"
}
$outputDirPath = if ([IO.Path]::IsPathRooted($OutputDir)) {
  $OutputDir
} else {
  Join-Path $workspaceRoot $OutputDir
}
New-Item -ItemType Directory -Force -Path $outputDirPath | Out-Null

$tex = Get-Content -Path $sourcePath -Raw -Encoding UTF8
$preamble = Get-Preamble -Tex $tex
$tempRoot = Join-Path $workspaceRoot ".codex/tmp/tikz-svg"
New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

$jobs = @()
if ($PSCmdlet.ParameterSetName -eq "Macro") {
  $macroBody = if ($Macro.StartsWith("\")) { $Macro } else { "\" + $Macro }
  $name = if ($OutputName) { $OutputName } else { (Get-SafeName $Macro) + ".svg" }
  $jobs += [pscustomobject]@{ Body = $macroBody; Name = $name }
}
elseif ($PSCmdlet.ParameterSetName -eq "Snippet") {
  $name = if ($OutputName) { $OutputName } else { "snippet.svg" }
  $jobs += [pscustomobject]@{ Body = $Snippet; Name = $name }
}
elseif ($PSCmdlet.ParameterSetName -eq "AllTikz") {
  $matches = [regex]::Matches($tex, "\\begin\{tikzpicture\}[\s\S]*?\\end\{tikzpicture\}")
  if ($matches.Count -eq 0) {
    throw "No direct tikzpicture environments were found in '$SourceTex'. Use -Macro or -Snippet for macro-defined figures."
  }
  $i = 1
  foreach ($m in $matches) {
    $jobs += [pscustomobject]@{
      Body = $m.Value
      Name = ("tikz-{0:D3}.svg" -f $i)
    }
    $i++
  }
}

$rendered = @()
$tempDirs = @()
foreach ($job in $jobs) {
  $outPath = Join-Path $outputDirPath $job.Name
  $tempDirs += Invoke-Render `
    -Preamble $preamble `
    -Body $job.Body `
    -OutPath $outPath `
    -TempRoot $tempRoot `
    -LatexExe $latexExe `
    -DvisvgmExe $dvisvgmExe `
    -KeepTextMode ([bool]$KeepText)
  $rendered += (Resolve-Path -LiteralPath $outPath).Path
}

if (-not $KeepTemp) {
  foreach ($dir in $tempDirs) {
    if ((Test-Path -LiteralPath $dir) -and $dir.StartsWith($tempRoot)) {
      Remove-Item -LiteralPath $dir -Recurse -Force
    }
  }
}

Write-Host "Rendered SVG files:"
foreach ($file in $rendered) {
  Write-Host " - $file"
}
