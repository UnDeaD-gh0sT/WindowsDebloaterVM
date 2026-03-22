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

# Clean previous temp folder (ignore if locked)
if (Test-Path $TempPath) {
    try {
        Remove-Item $TempPath -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Host "Warning: Could not delete old temp folder (it may be in use). Using existing one." -ForegroundColor Yellow
    }
}

New-Item -Path $TempPath -ItemType Directory -Force | Out-Null
New-Item -Path "$TempPath\Modules" -ItemType Directory -Force | Out-Null

Write-Host "Downloading files..." -ForegroundColor Yellow

$files = @("GUI-Menu.ps1", "Modules/Remove-Apps.ps1", "Modules/Disable-Services.ps1")

foreach ($file in $files) {
    Invoke-RestMethod -Uri "$RepoBase/$file" -OutFile "$TempPath/$file"
    Write-Host "  ✓ $file" -ForegroundColor Green
}

Write-Host "Launching GUI..." -ForegroundColor Green
Set-Location $TempPath
& "$TempPath\GUI-Menu.ps1"

Write-Host "Done. Temp folder is at: $TempPath" -ForegroundColor Yellow
Write-Host "You can delete it manually anytime." -ForegroundColor Gray

Write-Host "Session finished." -ForegroundColor Green