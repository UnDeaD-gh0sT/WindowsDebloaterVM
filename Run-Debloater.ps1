# UltraDebloater Launcher - 2026 Edition
# Run this as Administrator

Write-Host "=== Windows VM UltraDebloater ===" -ForegroundColor Cyan
Write-Host "Downloading latest menu (no files saved permanently)..." -ForegroundColor Yellow

$menu = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/YOURUSERNAME/Windows-VM-UltraDebloater/main/GUI-Menu.ps1"
Invoke-Expression $menu

Write-Host "Done." -ForegroundColor Green