# =============================================================================
# GUI-Menu.ps1 - Main Interface (now with background job for responsiveness)
# =============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows VM UltraDebloater - RE/Testing Edition"
$form.Size = New-Object System.Drawing.Size(820, 680)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$form.ForeColor = [System.Drawing.Color]::White

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "UltraDebloater - Select what to remove/disable"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($lblTitle)

$gbAggression = New-Object System.Windows.Forms.GroupBox
$gbAggression.Text = "Aggression Level"
$gbAggression.Location = New-Object System.Drawing.Point(20, 50)
$gbAggression.Size = New-Object System.Drawing.Size(760, 60)
$form.Controls.Add($gbAggression)

$rdoLite = New-Object System.Windows.Forms.RadioButton
$rdoLite.Text = "Lite (apps + basic telemetry)"
$rdoLite.Location = New-Object System.Drawing.Point(20, 25)
$rdoLite.AutoSize = $true
$gbAggression.Controls.Add($rdoLite)

$rdoAggressive = New-Object System.Windows.Forms.RadioButton
$rdoAggressive.Text = "Aggressive (apps + services + privacy)"
$rdoAggressive.Location = New-Object System.Drawing.Point(220, 25)
$rdoAggressive.AutoSize = $true
$rdoAggressive.Checked = $true
$gbAggression.Controls.Add($rdoAggressive)

$rdoNuclear = New-Object System.Windows.Forms.RadioButton
$rdoNuclear.Text = "Nuclear (everything + WinSxS reset)"
$rdoNuclear.Location = New-Object System.Drawing.Point(480, 25)
$rdoNuclear.AutoSize = $true
$gbAggression.Controls.Add($rdoNuclear)

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(20, 120)
$tabControl.Size = New-Object System.Drawing.Size(760, 420)
$form.Controls.Add($tabControl)

$tabApps = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "Apps / Appx"
$tabControl.TabPages.Add($tabApps)

$chkXbox = New-Object System.Windows.Forms.CheckBox
$chkXbox.Text = "Xbox (GameBar, TCUI, Identity, etc.)"
$chkXbox.Location = New-Object System.Drawing.Point(20, 30)
$chkXbox.AutoSize = $true
$tabApps.Controls.Add($chkXbox)

$chkOneDrive = New-Object System.Windows.Forms.CheckBox
$chkOneDrive.Text = "OneDrive (full removal)"
$chkOneDrive.Location = New-Object System.Drawing.Point(20, 60)
$chkOneDrive.AutoSize = $true
$tabApps.Controls.Add($chkOneDrive)

$chkStore = New-Object System.Windows.Forms.CheckBox
$chkStore.Text = "Microsoft Store"
$chkStore.Location = New-Object System.Drawing.Point(20, 90)
$chkStore.AutoSize = $true
$tabApps.Controls.Add($chkStore)

$chkEdge = New-Object System.Windows.Forms.CheckBox
$chkEdge.Text = "Microsoft Edge (deep removal)"
$chkEdge.Location = New-Object System.Drawing.Point(20, 120)
$chkEdge.AutoSize = $true
$tabApps.Controls.Add($chkEdge)

$chkCortana = New-Object System.Windows.Forms.CheckBox
$chkCortana.Text = "Cortana + AI features"
$chkCortana.Location = New-Object System.Drawing.Point(20, 150)
$chkCortana.AutoSize = $true
$tabApps.Controls.Add($chkCortana)

$chkNews = New-Object System.Windows.Forms.CheckBox
$chkNews.Text = "News / Widgets / Feeds"
$chkNews.Location = New-Object System.Drawing.Point(20, 180)
$chkNews.AutoSize = $true
$tabApps.Controls.Add($chkNews)

$tabServices = New-Object System.Windows.Forms.TabPage
$tabServices.Text = "Services"
$tabControl.TabPages.Add($tabServices)

$lstServices = New-Object System.Windows.Forms.CheckedListBox
$lstServices.Location = New-Object System.Drawing.Point(20, 20)
$lstServices.Size = New-Object System.Drawing.Size(700, 350)
$lstServices.CheckOnClick = $true
$lstServices.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
$lstServices.ForeColor = [System.Drawing.Color]::White

$servicesList = @("DiagTrack", "dmwappushservice", "WSearch", "SysMain", "lfsvc", "XblAuthManager", "XblGameSave", "XboxNetApiSvc", "WerSvc", "DoSvc")
foreach ($svc in $servicesList) { $lstServices.Items.Add($svc) | Out-Null }
$tabServices.Controls.Add($lstServices)

$btnRestorePoint = New-Object System.Windows.Forms.Button
$btnRestorePoint.Text = "Create System Restore Point First"
$btnRestorePoint.Location = New-Object System.Drawing.Point(20, 560)
$btnRestorePoint.Size = New-Object System.Drawing.Size(280, 50)
$btnRestorePoint.BackColor = [System.Drawing.Color]::FromArgb(0,120,215)
$btnRestorePoint.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($btnRestorePoint)

$btnExecute = New-Object System.Windows.Forms.Button
$btnExecute.Text = "EXECUTE SELECTED CHANGES"
$btnExecute.Location = New-Object System.Drawing.Point(520, 560)
$btnExecute.Size = New-Object System.Drawing.Size(260, 50)
$btnExecute.BackColor = [System.Drawing.Color]::IndianRed
$btnExecute.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($btnExecute)

$btnRevert = New-Object System.Windows.Forms.Button
$btnRevert.Text = "REVERT / UNDO (coming soon)"
$btnRevert.Location = New-Object System.Drawing.Point(320, 560)
$btnRevert.Size = New-Object System.Drawing.Size(180, 50)
$btnRevert.BackColor = [System.Drawing.Color]::DarkGray
$btnRevert.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($btnRevert)

# Status & Progress
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Ready"
$lblStatus.Location = New-Object System.Drawing.Point(20, 620)
$lblStatus.Size = New-Object System.Drawing.Size(760, 30)
$lblStatus.ForeColor = [System.Drawing.Color]::LimeGreen
$form.Controls.Add($lblStatus)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Style = "Marquee"
$progress.MarqueeAnimationSpeed = 30
$progress.Location = New-Object System.Drawing.Point(20, 580)
$progress.Size = New-Object System.Drawing.Size(760, 20)
$progress.Visible = $false
$form.Controls.Add($progress)

# Restore Point button
$btnRestorePoint.Add_Click({
    try {
        Checkpoint-Computer -Description "UltraDebloater - Pre-debloat" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
        [System.Windows.Forms.MessageBox]::Show("Restore point created.", "Success")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed: $($_.Exception.Message)`n`nContinue anyway?", "Warning")
    }
})

# Execute button with background job
$btnExecute.Add_Click({
    $confirmation = [System.Windows.Forms.MessageBox]::Show(
        "Apply changes in background?`nGUI stays responsive.`n`nSnapshot VM first!",
        "Confirm",
        "YesNo",
        "Warning"
    )

    if ($confirmation -eq "Yes") {
        $form.Enabled = $false
        $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor

        $lblStatus.Text = "Starting background job..."
        $lblStatus.ForeColor = [System.Drawing.Color]::Yellow
        $progress.Visible = $true
        $form.Refresh()

        $job = Start-Job -ScriptBlock {
            param($xbox, $oneDrive, $store, $edge, $cortana, $news, $services)

            Import-Module "$using:PSScriptRoot\Modules\Remove-Apps.ps1" -Force
            Import-Module "$using:PSScriptRoot\Modules\Disable-Services.ps1" -Force

            Remove-SelectedApps -Xbox $xbox -OneDrive $oneDrive -Store $store -Edge $edge -Cortana $cortana -News $news

            if ($services.Count -gt 0) {
                Disable-SelectedServices -SelectedServices $services
            }

            "DONE" | Out-File "$env:TEMP\UltraDebloater_job_done.txt"
        } -ArgumentList $chkXbox.Checked, $chkOneDrive.Checked, $chkStore.Checked, $chkEdge.Checked, $chkCortana.Checked, $chkNews.Checked, ($lstServices.CheckedItems | % { $_.ToString() })

        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 2000
        $timer.Add_Tick({
            if ($job.State -eq "Completed") {
                $timer.Stop()
                $timer.Dispose()
                $progress.Visible = $false
                $lblStatus.Text = "Job completed! Check logs."
                $lblStatus.ForeColor = [System.Drawing.Color]::LimeGreen
                $form.Enabled = $true
                $form.Cursor = [System.Windows.Forms.Cursors]::Default

                Receive-Job $job -AutoRemoveJob
                [System.Windows.Forms.MessageBox]::Show("Finished. Reboot recommended.", "Done")
            } elseif ($job.State -eq "Failed") {
                $timer.Stop()
                $lblStatus.Text = "Job failed - check console"
                $lblStatus.ForeColor = [System.Drawing.Color]::Red
                $form.Enabled = $true
                Receive-Job $job -ErrorAction SilentlyContinue
            }
        })
        $timer.Start()
    }
})

$form.ShowDialog() | Out-Null