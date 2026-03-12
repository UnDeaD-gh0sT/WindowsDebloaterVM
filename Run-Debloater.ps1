# =============================================================================
# Windows VM UltraDebloater <> Launcher (2025/2026 edition)
#
# How to run:
#   irm https://raw.githubusercontent.com/UnDeaD-gh0sT/WindowsDebloaterVM/main/Run-Debloater.ps1 | iex
#
# =============================================================================

Clear-Host
$TempPath = "$env:TEMP\UltraDebloater"
$RepoBase = "https://raw.githubusercontent.com/UnDeaD-gh0sT/WindowsDebloaterVM/main"

Write-Host "┌──────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│             Windows VM UltraDebloater Launcher               │" -ForegroundColor Cyan
Write-Host "│                                                              │" -ForegroundColor Cyan
Write-Host "│   Selective, aggressive, safe — with full revert option      │" -ForegroundColor Cyan
Write-Host "│                                                              │" -ForegroundColor Cyan
Write-Host "└──────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking execution policy..." -ForegroundColor Yellow
if ((Get-ExecutionPolicy -Scope Process) -ne 'Bypass') {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
}

# Create temp folder
if (Test-Path $TempPath) { Remove-Item $TempPath -Recurse -Force }
New-Item -Path $TempPath -ItemType Directory -Force | Out-Null
New-Item -Path "$TempPath\Modules" -ItemType Directory -Force | Out-Null

Write-Host "Downloading files to $TempPath ..." -ForegroundColor Yellow

# Download all files
$files = @(
    "GUI-Menu.ps1",
    "Modules/Remove-Apps.ps1",
    "Modules/Disable-Services.ps1"   # add more later when we create them
)

foreach ($file in $files) {
    $url = "$RepoBase/$file"
    $out = "$TempPath/$file"
    try {
        Invoke-RestMethod -Uri $url -OutFile $out -UseBasicParsing
        Write-Host "  ✓ Downloaded $file" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed to download $file" -ForegroundColor Red
        exit 1
    }
}

Write-Host "All files downloaded. Launching GUI from local folder..." -ForegroundColor Green

# Run the GUI from real disk (now $PSScriptRoot works)
Set-Location $TempPath
& "$TempPath\GUI-Menu.ps1"

Write-Host "Cleanup temp folder? (Y/N)" -ForegroundColor Yellow
$cleanup = Read-Host
if ($cleanup -match '^y') {
    Remove-Item $TempPath -Recurse -Force
    Write-Host "Temp folder cleaned." -ForegroundColor Green
}

Write-Host "Session finished." -ForegroundColor Green