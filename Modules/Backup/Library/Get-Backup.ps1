# ----------
# Get-Backup
# ----------

<#
.SYNOPSIS
Get-Backup: Get the list of backups.
.DESCRIPTION
Returns the directory listing of the backup directory.
.PARAMETER Filter
Filter the list of backup items by name.
.PARAMETER BackupPath
Specify the location of the backups directory.
.EXAMPLE
Get-Backup
Returns a list of all backups.
.EXAMPLE
Get-Backup -Filter '*Console*'
Returns a list of backups that match the given criteria.
#>
function Get-Backup(
    # Filter the list of backup items
    [Alias("Name", "Item")]
    [string] $Filter,

    # Backups location
    [ValidateScript({ Test-Path $_ })]
    [Alias("Path", "Destination", "DestinationPath")]
    [string]$BackupPath = $Script:BACKUP_PATH
) {
    return Get-ChildItem -Path $BackupPath -Exclude '__BACKUPS__.csv' -Filter $Filter | Sort-Object LastWriteTime -Descending
}
