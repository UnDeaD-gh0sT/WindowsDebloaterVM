# =============================================================================
# GUI-Menu.ps1 - Main UltraDebloater Interface (fetched & executed by launcher)
# Requires -RunAsAdministrator (launcher should ensure this)
# =============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ------------------------------------------------------------------------------
# Create main form
# ------------------------------------------------------------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows VM UltraDebloater - RE/Testing Edition"
$form.Size = New-Object System.Drawing.Size(820, 680)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$form.ForeColor = [System.Drawing.Color]::White

# Title label
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "UltraDebloater - Select what to remove/disable"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($lblTitle)

# Aggression level group
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

# Tab control for categories
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(20, 120)
$tabControl.Size = New-Object System.Drawing.Size(760, 420)
$form.Controls.Add($tabControl)

# Tab: Apps
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

# More checkboxes can be added here later...

# Tab: Services
$tabServices = New-Object System.Windows.Forms.TabPage
$tabServices.Text = "Services"
$tabControl.TabPages.Add($tabServices)

$lstServices = New-Object System.Windows.Forms.CheckedListBox
$lstServices.Location = New-Object System.Drawing.Point(20, 20)
$lstServices.Size = New-Object System.Drawing.Size(700, 350)
$lstServices.CheckOnClick = $true
$lstServices.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
$lstServices.ForeColor = [System.Drawing.Color]::White

$servicesList = @(
    "DiagTrack",              # Telemetry
    "dmwappushservice",       # Push notifications / telemetry
    "WSearch",                # Windows Search
    "SysMain",                # Superfetch / Prefetch
    "lfsvc",                  # Geolocation
    "XblAuthManager", "XblGameSave", "XboxNetApiSvc",  # Xbox
    "WerSvc",                 # Error reporting
    "DoSvc"                   # Delivery Optimization
)

foreach ($svc in $servicesList) {
    $lstServices.Items.Add($svc) | Out-Null
}
$tabServices.Controls.Add($lstServices)

# Bottom buttons
$btnRestorePoint = New-Object System.Windows.Forms.Button
$btnRestorePoint.Text = "Create System Restore Point First"
$btnRestorePoint.Location = New-Object System.Drawing.Point(20, 560)
$btnRestorePoint.Size = New-Object System.Drawing.Size(280, 50)
$btnRestorePoint.BackColor = [System.Drawing.Color]::FromArgb(0,120,215)
$btnRestorePoint.ForeColor = [System.Drawing.Color]::White
$btnRestorePoint.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnRestorePoint)

$btnExecute = New-Object System.Windows.Forms.Button
$btnExecute.Text = "EXECUTE SELECTED CHANGES"
$btnExecute.Location = New-Object System.Drawing.Point(520, 560)
$btnExecute.Size = New-Object System.Drawing.Size(260, 50)
$btnExecute.BackColor = [System.Drawing.Color]::IndianRed
$btnExecute.ForeColor = [System.Drawing.Color]::White
$btnExecute.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnExecute)

$btnRevert = New-Object System.Windows.Forms.Button
$btnRevert.Text = "REVERT / UNDO (coming soon)"
$btnRevert.Location = New-Object System.Drawing.Point(320, 560)
$btnRevert.Size = New-Object System.Drawing.Size(180, 50)
$btnRevert.BackColor = [System.Drawing.Color]::DarkGray
$btnRevert.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($btnRevert)

# ------------------------------------------------------------------------------
# Button actions
# ------------------------------------------------------------------------------

$btnRestorePoint.Add_Click({
    Write-Host "Creating system restore point..." -ForegroundColor Yellow
    Checkpoint-Computer -Description "UltraDebloater - Pre-debloat" -RestorePointType "MODIFY_SETTINGS"
    [System.Windows.Forms.MessageBox]::Show("Restore point created successfully.`n`nYou can now safely apply changes.", "Success", "OK", "Information")
})

$btnExecute.Add_Click({
    $confirmation = [System.Windows.Forms.MessageBox]::Show(
        "This will apply the selected changes.`n`nAre you sure? (Snapshot your VM first!)",
        "Confirm Debloat",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )

    if ($confirmation -eq "Yes") {
        $form.Enabled = $false
        $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor

        # Aggression-based auto-select (example)
        if ($rdoNuclear.Checked) {
            $chkXbox.Checked = $true
            $chkOneDrive.Checked = $true
            $chkStore.Checked = $true
            $chkEdge.Checked = $true
            $chkCortana.Checked = $true
            $chkNews.Checked = $true
            foreach ($i in 0..($lstServices.Items.Count-1)) { $lstServices.SetItemChecked($i, $true) }
        }
        # Import modules
        Import-Module "$PSScriptRoot\Modules\Remove-Apps.ps1" -Force

        # Call the function with checkbox states
        Remove-SelectedApps -Xbox $chkXbox.Checked `
                    -OneDrive $chkOneDrive.Checked `
                    -Store $chkStore.Checked `
                    -Edge $chkEdge.Checked `
                    -Cortana $chkCortana.Checked `
                    -News $chkNews.Checked

        # Execute app removals
        if ($chkXbox.Checked) {
            Get-AppxPackage *xbox* -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like "*xbox*"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Host "Xbox components removed."
        }

        if ($chkOneDrive.Checked) {
            # Basic OneDrive removal (expand later with deep function)
            taskkill /f /im OneDrive.exe 2>$null
            & "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
            Write-Host "OneDrive removal attempted."
        }

        # Services -- imoprt module from Module/Disable-Services.ps1
        Import-Module "$PSScriptRoot\Modules\Disable-Services.ps1" -Force -ErrorAction SilentlyContinue

        if ($lstServices.CheckedItems.Count -gt 0) {
            $checkedServices = $lstServices.CheckedItems | ForEach-Object { $_.ToString() }
            Disable-SelectedServices -SelectedServices $checkedServices
        } else {
            Write-Output "No services selected for disabling."
        }

        # Placeholder for more actions (privacy, WinSxS, etc.)

        $form.Enabled = $true
        $form.Cursor = [System.Windows.Forms.Cursors]::Default

        [System.Windows.Forms.MessageBox]::Show("Changes applied.`n`nReboot recommended for full effect.", "Done", "OK", "Information")
    }
})

$btnRevert.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Revert function is not implemented yet.`n`nNext update will include full undo (re-enable services, re-register apps, etc.).", "Info", "OK", "Information")
})

# Show the form
$form.ShowDialog() | Out-Null