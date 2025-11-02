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

    # Also remove matrix output stored in build\output\data3 (no extension)
    $matrixPath = Join-Path -Path (Join-Path -Path "build" -ChildPath "output") -ChildPath "data3"
    if (Test-Path -LiteralPath $matrixPath) {
        $items += (Get-Item -LiteralPath $matrixPath)
    }

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
