# =============================================================================
# Windows VM UltraDebloater - Launcher (2025/2026 edition)
# One command to rule them all — no permanent downloads required
#
# How to run:
#   irm https://raw.githubusercontent.com/UnDeaD-gh0sT/WindowsDebloaterVM/main/Run-Debloater.ps1 | iex
#
# =============================================================================

Clear-Host

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

Write-Host "Fetching latest GUI menu from GitHub..." -ForegroundColor Yellow
Write-Host ""

try {
    $menuUrl = "https://raw.githubusercontent.com/UnDeaD-gh0sT/WindowsDebloaterVM/main/GUI-menu.ps1"
    $menuContent = Invoke-RestMethod -Uri $menuUrl -UseBasicParsing -ErrorAction Stop

    if ([string]::IsNullOrWhiteSpace($menuContent)) {
        throw "Downloaded script is empty"
    }

    Write-Host "Menu downloaded successfully. Launching interface..." -ForegroundColor Green
    Write-Host ""

    # Execute the downloaded GUI script in current scope
    Invoke-Expression $menuContent
}
catch {
    Write-Host "Error downloading or executing the menu:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible causes:" -ForegroundColor DarkYellow
    Write-Host "  • Wrong GitHub username/repo in the URL" -ForegroundColor DarkYellow
    Write-Host "  • File 'GUI-Menu.ps1' not uploaded yet" -ForegroundColor DarkYellow
    Write-Host "  • Network / GitHub rate limit issue" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "Session finished." -ForegroundColor Green