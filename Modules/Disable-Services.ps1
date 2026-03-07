# =============================================================================
# Disable-Services.ps1 - Safe stopping and disabling of selected services
# Called from GUI with list of checked service names
# =============================================================================

function Disable-SelectedServices {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$SelectedServices
    )

    $logPath = "$PSScriptRoot\..\Logs\Services-$(Get-Date -Format 'yyyyMMdd-HHmm').log"
    Start-Transcript -Path $logPath -Append -Force

    Write-Output "Starting service disable phase at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

    foreach ($serviceName in $SelectedServices) {
        try {
            $svc = Get-Service -Name $serviceName -ErrorAction Stop

            Write-Output "Processing service: $serviceName"

            if ($svc.Status -eq 'Running') {
                Write-Output "  → Stopping $serviceName ..."
                Stop-Service -Name $serviceName -Force -ErrorAction Stop
                Start-Sleep -Milliseconds 800  # small delay to let it stop cleanly
            }

            $currentStartup = (Get-Service -Name $serviceName).StartType
            if ($currentStartup -ne 'Disabled') {
                Write-Output "  → Setting startup type to Disabled (was $currentStartup)"
                Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
            } else {
                Write-Output "  → Already disabled"
            }

            Write-Output "  → $serviceName successfully handled"
        }
        catch {
            Write-Output "ERROR handling $serviceName : $($_.Exception.Message)"
            Write-Output "  (Skipping to next service)"
        }
    }

    Write-Output "Service disable phase completed at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Stop-Transcript
}

Export-ModuleMember -Function Disable-SelectedServices