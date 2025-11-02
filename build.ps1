Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path "build" -Force | Out-Null
function Has-Command($name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}
if (Has-Command 'cl') {
    Write-Host "Building with MSVC (cl) -> build\\pa_part1.exe"
    & cl /O2 /W4 /nologo /Fe:build\pa_part1.exe src\pa_part1.c
    if ($LASTEXITCODE -ne 0) { throw "cl build failed with exit code $LASTEXITCODE" }
} elseif (Has-Command 'gcc') {
    Write-Host "Building with GCC -> build\\pa_part1.exe"
    & gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part1.exe src/pa_part1.c
    if ($LASTEXITCODE -ne 0) { throw "gcc build failed with exit code $LASTEXITCODE" }
} else {
    Write-Error "Neither 'cl' nor 'gcc' found in PATH. Use MSVC Developer Command Prompt or install MinGW-w64."
    exit 1
}
Write-Host "Done. Run: .\\build\\pa_part1.exe"
