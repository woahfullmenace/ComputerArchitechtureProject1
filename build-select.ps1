param(
  [Parameter(Position=0)]
  [string] $PartSwitch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Has-Command($name) { return $null -ne (Get-Command $name -ErrorAction SilentlyContinue) }

if (-not (Test-Path build)) { New-Item -ItemType Directory -Path build -Force | Out-Null }

switch ($PartSwitch) {
  '-1' { $src = "src\pa_part1.c"; $out = "build\part1.exe"; break }
  '1'  { $src = "src\pa_part1.c"; $out = "build\part1.exe"; break }
  '-2' { $src = "src\computer architechture part 2.c"; $out = "build\part2.exe"; break }
  '2'  { $src = "src\computer architechture part 2.c"; $out = "build\part2.exe"; break }
  default {
    Write-Host "Usage: powershell -ExecutionPolicy Bypass -File .\build-select.ps1 -1 | -2"
    Write-Host "Builds selected part into build\\partX.exe"
    exit 1
  }
}

if (Has-Command 'cl') {
  Write-Host "Building with MSVC (cl) -> $out"
  & cl /O2 /W4 /nologo "/Fe:$out" "$src"
  if ($LASTEXITCODE -ne 0) { throw "cl build failed with exit code $LASTEXITCODE" }
} elseif (Has-Command 'gcc') {
  Write-Host "Building with GCC -> $out"
  & gcc -O3 -Wall -Wextra -std=c11 -o "$out" "$src"
  if ($LASTEXITCODE -ne 0) { throw "gcc build failed with exit code $LASTEXITCODE" }
} else {
  Write-Error "Neither 'cl' nor 'gcc' found in PATH."
  exit 1
}

Write-Host "Done. Run: .\\$out"

