# =============================================================================
# Remove-Apps.ps1 - Safe Appx + Provisioned + basic root cleanup
# Called from GUI with selected items
# =============================================================================

function Remove-SelectedApps {
    param(
        [bool]$Xbox,
        [bool]$OneDrive,
        [bool]$Store,
        [bool]$Edge,
        [bool]$Cortana,
        [bool]$News
    )

    $logPath = "$PSScriptRoot\..\Logs\Debloater-$(Get-Date -Format 'yyyyMMdd-HHmm').log"
    Start-Transcript -Path $logPath -Append

    try {
        if ($Xbox) {
            Write-Output "Removing Xbox components..."
            Get-AppxPackage -AllUsers "*xbox*" | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*xbox*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }

        if ($OneDrive) {
            Write-Output "Removing OneDrive (basic)..."
            taskkill /f /im OneDrive.exe 2>$null
            if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") {
                Start-Process "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait -NoNewWindow
            }
            # More deep removal in Deep-Removals.ps1 later
        }

        if ($Store) {
            Write-Output "Removing Microsoft Store..."
            Get-AppxPackage -AllUsers "*WindowsStore*" | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*WindowsStore*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }

        if ($Edge) {
            Write-Output "Removing Edge stubs (basic)..."
            Get-AppxPackage -AllUsers "*Edge*" | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*Edge*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            # Deep folder/registry in Deep-Removals.ps1
        }

        if ($Cortana) {
            Write-Output "Disabling Cortana..."
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
            # More in Privacy-Tweaks.ps1
        }

        if ($News) {
            Write-Output "Disabling News/Widgets..."
            reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f
        }

        Write-Output "App removal phase completed."
    }
    catch {
        Write-Output "Error in app removal: $($_.Exception.Message)"
    }
    finally {
        Stop-Transcript
    }
}

Export-ModuleMember -Function Remove-SelectedApps