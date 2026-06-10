param(
  [string]$ExamDir = "Examenes Pruebas estandarizadas"
)

$ErrorActionPreference = "Stop"

$base = Resolve-Path $ExamDir
$workspace = Resolve-Path (Join-Path $PSScriptRoot "..\..")

if (-not $base.Path.StartsWith($workspace.Path)) {
  throw "La carpeta de examenes debe estar dentro del workspace: $($base.Path)"
}

$logs = Join-Path $base "temporales\logs"
$previews = Join-Path $base "temporales\previews"
$checks = Join-Path $base "temporales\checks"

New-Item -ItemType Directory -Path $logs -Force | Out-Null
New-Item -ItemType Directory -Path $previews -Force | Out-Null
New-Item -ItemType Directory -Path $checks -Force | Out-Null

function Move-IfPresent {
  param(
    [string]$Filter,
    [string]$Destination,
    [switch]$Recurse
  )

  Get-ChildItem -Path $base -File -Filter $Filter -Recurse:$Recurse | Where-Object {
    -not $_.FullName.StartsWith((Join-Path $base "temporales"))
  } | ForEach-Object {
    $target = Join-Path $Destination $_.Name
    if (Test-Path -LiteralPath $target) {
      $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
      $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
      $ext = [System.IO.Path]::GetExtension($_.Name)
      $target = Join-Path $Destination "$name-$stamp$ext"
    }
    Move-Item -LiteralPath $_.FullName -Destination $target
  }
}

Move-IfPresent "*.aux" $logs -Recurse
Move-IfPresent "*.log" $logs -Recurse
Move-IfPresent "*_page-*.png" $previews -Recurse
Move-IfPresent "*_check_page-*.png" $previews -Recurse
Move-IfPresent "*_check.pdf" $checks -Recurse

Write-Host "Limpieza terminada: auxiliares movidos a temporales."
