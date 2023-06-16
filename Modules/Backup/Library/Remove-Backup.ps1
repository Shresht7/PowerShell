# -------------
# Remove-Backup
# -------------

<#
.SYNOPSIS
Remove-Backup: Remove old backups.
.DESCRIPTION
Remove old backup entries older than the retention period (default: 31 days).
.PARAMETER Name
Wildcard name to filter the backups.
.PARAMETER Age
Only remove backups older than the given age (in days). Default is 31 days.
.PARAMETER BackupPath
Path to the backup folder.
.PARAMETER WhatIf
Only show the potential action without performing it.
.PARAMETER Confirm
Confirm before performing the action.
.EXAMPLE
Remove-Backup
Removes any backups that are older than the default age (31 days).
.EXAMPLE
Remove-Backup -Age 5
Remove any backups that are older than 5 days.
.EXAMPLE
Remove-Backup -Name '*Console*' -Age 14
Removes any backups that match the wildcard `*Console*` and are older than 14 days.
.EXAMPLE
Remove-Backup -Name '*.ps1' -WhatIf
Shows what will happen if you perform the action `Remove-Backup -Name '*.ps1'`.
.EXAMPLE
Remove-Backup -Age 7 -Confirm
Asks to confirm before deleting any backups older than 7 days.
#>
function Remove-Backup(
    [String]$Name,
        
    # TODO: Change this to UInt32 to prevent adding negative days. (Ok while testing)
    [Int32]$Age = 31, # TODO: Update the age to something more sensible (like a year or something)
    
    # Path to the backup folder
    [ValidateScript({ Test-Path -Path $_ })]
    [String]$BackupPath = $Script:BACKUP_PATH,

    # Only show the potential action without performing it
    [switch] $WhatIf,

    # Confirm before performing the action
    [switch] $Confirm
) {
    # Get the list of backups that match the given criteria
    $BackupItems = if ($null -eq $Name) { Get-ChildItem -Path $BackupPath } else { Get-ChildItem -Path $BackupItems -Filter $Name }

    # Remove backups older than the set age (in days)
    $BackupItems | Where-Object { (Get-Date) -lt $_.LastAccessTime.AddDays(-$days) } | Remove-Item -Recurse -Confirm:$Confirm -WhatIf:$WhatIf
}
