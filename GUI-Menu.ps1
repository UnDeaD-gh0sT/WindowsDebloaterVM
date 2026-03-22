# =============================================================================
# GUI-Menu.ps1 - Clean & Responsive Version (No jobs, no timers)
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
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($lblTitle)

# Aggression level (same as before)
$gbAggression = New-Object System.Windows.Forms.GroupBox
$gbAggression.Text = "Aggression Level"
$gbAggression.Location = New-Object System.Drawing.Point(20, 50)
$gbAggression.Size = New-Object System.Drawing.Size(760, 60)
$form.Controls.Add($gbAggression)

$rdoAggressive = New-Object System.Windows.Forms.RadioButton { Text = "Aggressive (recommended)", Location = New-Object System.Drawing.Point(20, 25), AutoSize = $true, Checked = $true }
$gbAggression.Controls.Add($rdoAggressive)

# Tabs & checkboxes (shortened for speed)
$tabControl = New-Object System.Windows.Forms.TabControl { Location = New-Object System.Drawing.Point(20, 120), Size = New-Object System.Drawing.Size(760, 420) }
$form.Controls.Add($tabControl)

$tabApps = New-Object System.Windows.Forms.TabPage { Text = "Apps" }
$tabControl.TabPages.Add($tabApps)

$chkXbox     = New-Object System.Windows.Forms.CheckBox { Text = "Xbox", Location = New-Object System.Drawing.Point(20,30), AutoSize = $true }
$chkOneDrive = New-Object System.Windows.Forms.CheckBox { Text = "OneDrive", Location = New-Object System.Drawing.Point(20,60), AutoSize = $true }
$chkStore    = New-Object System.Windows.Forms.CheckBox { Text = "Microsoft Store", Location = New-Object System.Drawing.Point(20,90), AutoSize = $true }
$chkEdge     = New-Object System.Windows.Forms.CheckBox { Text = "Microsoft Edge", Location = New-Object System.Drawing.Point(20,120), AutoSize = $true }

$tabApps.Controls.AddRange(@($chkXbox, $chkOneDrive, $chkStore, $chkEdge))

$tabServices = New-Object System.Windows.Forms.TabPage { Text = "Services" }
$tabControl.TabPages.Add($tabServices)

$lstServices = New-Object System.Windows.Forms.CheckedListBox { Location = New-Object System.Drawing.Point(20,20), Size = New-Object System.Drawing.Size(700,350), CheckOnClick = $true }
$services = @("DiagTrack","WSearch","SysMain","lfsvc","XblAuthManager","XboxNetApiSvc","WerSvc","DoSvc")
foreach ($s in $services) { $lstServices.Items.Add($s) }
$tabServices.Controls.Add($lstServices)

# Buttons
$btnRestore = New-Object System.Windows.Forms.Button { Text = "Create Restore Point", Location = New-Object System.Drawing.Point(20,560), Size = New-Object System.Drawing.Size(250,50), BackColor = "DodgerBlue" }
$btnExecute = New-Object System.Windows.Forms.Button { Text = "EXECUTE SELECTED CHANGES", Location = New-Object System.Drawing.Point(520,560), Size = New-Object System.Drawing.Size(260,50), BackColor = "IndianRed", ForeColor = "White" }
$form.Controls.AddRange(@($btnRestore, $btnExecute))

# Status label
$lblStatus = New-Object System.Windows.Forms.Label { Text = "Ready - Click Execute", Location = New-Object System.Drawing.Point(20,620), Size = New-Object System.Drawing.Size(760,30), ForeColor = "Lime" }
$form.Controls.Add($lblStatus)

# Restore Point
$btnRestore.Add_Click({ Checkpoint-Computer -Description "UltraDebloater" -RestorePointType MODIFY_SETTINGS })

# Execute - Simple + Responsive
$btnExecute.Add_Click({
    if ([System.Windows.Forms.MessageBox]::Show("Apply now?", "Confirm", "YesNo") -ne "Yes") { return }

    $lblStatus.Text = "Working... (GUI should stay responsive)"
    $lblStatus.ForeColor = "Yellow"
    $form.Refresh()

    Import-Module "$PSScriptRoot\Modules\Remove-Apps.ps1" -Force
    Import-Module "$PSScriptRoot\Modules\Disable-Services.ps1" -Force

    Remove-SelectedApps -Xbox $chkXbox.Checked -OneDrive $chkOneDrive.Checked -Store $chkStore.Checked -Edge $chkEdge.Checked

    $checkedSvcs = $lstServices.CheckedItems | ForEach-Object { $_.ToString() }
    if ($checkedSvcs.Count -gt 0) { Disable-SelectedServices -SelectedServices $checkedSvcs }

    [System.Windows.Forms.Application]::DoEvents()
    $lblStatus.Text = "Done! Check Logs folder. Reboot recommended."
    $lblStatus.ForeColor = "Lime"
})

$form.ShowDialog() | Out-Null