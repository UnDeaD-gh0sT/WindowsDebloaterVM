# Better fonts everywhere
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Status label at bottom
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Ready - Select options and click Execute"
$lblStatus.Location = New-Object System.Drawing.Point(20, 620)
$lblStatus.Size = New-Object System.Drawing.Size(760, 30)
$lblStatus.ForeColor = [System.Drawing.Color]::LimeGreen
$lblStatus.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$lblStatus.TextAlign = "MiddleLeft"
$form.Controls.Add($lblStatus)

# Flat buttons example
$btnExecute.FlatStyle = "Flat"
$btnExecute.FlatAppearance.BorderSize = 0
$btnExecute.BackColor = [System.Drawing.Color]::FromArgb(220,53,69)   # Red-ish
$btnExecute.ForeColor = [System.Drawing.Color]::White

$btnRestorePoint.FlatStyle = "Flat"
$btnRestorePoint.FlatAppearance.BorderSize = 0
$btnRestorePoint.BackColor = [System.Drawing.Color]::FromArgb(0,123,255)
$btnRestorePoint.ForeColor = [System.Drawing.Color]::White

# ProgressBar (marquee style during apply)
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Style = "Marquee"
$progress.MarqueeAnimationSpeed = 30
$progress.Location = New-Object System.Drawing.Point(20, 570)
$progress.Size = New-Object System.Drawing.Size(760, 20)
$progress.Visible = $false
$form.Controls.Add($progress)

# In Execute click handler:
$btnExecute.Add_Click({
    ...
    $lblStatus.Text = "Applying changes... Please wait"
    $lblStatus.ForeColor = [System.Drawing.Color]::Yellow
    $progress.Visible = $true
    $form.Refresh()

    # ... your removal code ...

    $progress.Visible = $false
    $lblStatus.Text = "Changes applied successfully. Reboot recommended."
    $lblStatus.ForeColor = [System.Drawing.Color]::LimeGreen
})