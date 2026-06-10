param(
  [Parameter(Mandatory = $true)]
  [string]$TexPath
)

$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$pdflatex = Join-Path $projectRoot ".codex\tools\miktex-portable\texmfs\install\miktex\bin\x64\pdflatex.exe"

if (-not (Test-Path -LiteralPath $pdflatex)) {
  throw "No se encontro pdflatex en: $pdflatex"
}

$resolvedTex = Resolve-Path -LiteralPath $TexPath
$outputDir = Split-Path -Parent $resolvedTex

& $pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$outputDir" "$resolvedTex"
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& $pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$outputDir" "$resolvedTex"
exit $LASTEXITCODE
