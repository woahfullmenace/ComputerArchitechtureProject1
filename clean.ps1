param(
    [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    $items = @()

    # All .exe files recursively
    $exeFiles = Get-ChildItem -Path . -Recurse -Filter *.exe -File -ErrorAction SilentlyContinue
    if ($exeFiles) { $items += $exeFiles }

    # Also remove matrix outputs stored in build\output (no extension)
    $outDir = Join-Path -Path "build" -ChildPath "output"
    $matrixPath1 = Join-Path -Path $outDir -ChildPath "data3"
    $matrixPath2 = Join-Path -Path $outDir -ChildPath "data3_part2"
    if (Test-Path -LiteralPath $matrixPath1) { $items += (Get-Item -LiteralPath $matrixPath1) }
    if (Test-Path -LiteralPath $matrixPath2) { $items += (Get-Item -LiteralPath $matrixPath2) }

    if (-not $items -or $items.Count -eq 0) {
        Write-Host "Nothing to clean."
        exit 0
    }

    foreach ($f in $items) {
        if ($DryRun) {
            Write-Host "[DRY] Would delete: $($f.FullName)"
        } else {
            try {
                Remove-Item -LiteralPath $f.FullName -Force -ErrorAction Stop
                Write-Host "Deleted: $($f.FullName)"
            } catch {
                Write-Warning "Failed to delete: $($f.FullName) -> $($_.Exception.Message)"
            }
        }
    }
} catch {
    Write-Error $_
    exit 1
}
