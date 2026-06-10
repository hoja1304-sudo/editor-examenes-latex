param(
  [Parameter(Mandatory = $true)]
  [string]$TexPath,

  [Parameter(Mandatory = $true)]
  [string]$HtmlPath
)

$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$pdflatex = Join-Path $projectRoot ".codex\tools\miktex-portable\texmfs\install\miktex\bin\x64\pdflatex.exe"
$dvisvgm = Join-Path $projectRoot ".codex\tools\miktex-portable\texmfs\install\miktex\bin\x64\dvisvgm.exe"

if (-not (Test-Path -LiteralPath $pdflatex)) { throw "No se encontro pdflatex en: $pdflatex" }
if (-not (Test-Path -LiteralPath $dvisvgm)) { throw "No se encontro dvisvgm en: $dvisvgm" }

$resolvedTex = Resolve-Path -LiteralPath $TexPath
$resolvedHtml = Resolve-Path -LiteralPath $HtmlPath
$texContent = Get-Content -Raw -LiteralPath $resolvedTex
$htmlContent = Get-Content -Raw -LiteralPath $resolvedHtml

$matches = [regex]::Matches($texContent, "(?s)\\begin\{tikzpicture\}.*?\\end\{tikzpicture\}")
if ($matches.Count -eq 0) { throw "No se encontraron bloques tikzpicture en $resolvedTex" }

$workDir = Join-Path $projectRoot ".codex\tmp\tikz-html"
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

for ($i = 0; $i -lt $matches.Count; $i++) {
  $n = $i + 1
  $tikz = $matches[$i].Value
  $figureBase = "tikz-figure-$n"
  $figureTex = Join-Path $workDir "$figureBase.tex"
  $figurePdf = Join-Path $workDir "$figureBase.pdf"
  $figureSvg = Join-Path $workDir "$figureBase.svg"

  $standalone = @"
\documentclass[tikz,border=2pt]{standalone}
\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage{amsmath,amssymb}
\usepackage{tikz}
\usetikzlibrary{babel}
\newcommand{\puntografico}{0.75}
\begin{document}
$tikz
\end{document}
"@

  Set-Content -LiteralPath $figureTex -Value $standalone -Encoding UTF8
  & $pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$workDir" "$figureTex" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "pdflatex fallo al compilar la figura $n" }

  & $dvisvgm --pdf --no-fonts --exact --output="$figureSvg" "$figurePdf" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "dvisvgm fallo al convertir la figura $n" }

  $svg = Get-Content -Raw -LiteralPath $figureSvg
  $svg = [regex]::Replace($svg, "(?s)^.*?(<svg\b)", '$1')
  $svg = $svg -replace '<svg ', '<svg class="figura figura-latex" '
  $svg = $svg -replace '<title>.*?</title>', ''
  $svg = $svg.Replace('`', '\`').Replace('${', '\${')

  $pattern = "(?s)const FIGURA_$n = `.*?`;"
  $replacement = 'const FIGURA_' + $n + ' = `' + $svg + '`;'
  $htmlContent = [regex]::Replace($htmlContent, $pattern, $replacement, 1)
}

Set-Content -LiteralPath $resolvedHtml -Value $htmlContent -Encoding UTF8
Write-Output "Renderizadas $($matches.Count) figura(s) TikZ e incrustadas en $resolvedHtml"
