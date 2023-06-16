<#
.SYNOPSIS
Get the status of backups.
.DESCRIPTION
Retrieves information about the current status of backups in the specified backup path.
.PARAMETER Path
The path to the backup folder. Defaults to the script's BACKUP_PATH variable.
.EXAMPLE
Backup-Status
Gets the status of backups using the default backup path.
.EXAMPLE
Backup-Status -Path "C:\Backup"
Gets the status of backups in the specified path "C:\Backup".
#>

function Show-BackupStatus {
    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path $_ })]
        [Alias("BackupPath")]
        [string]$Path = $Script:BACKUP_PATH
    )

    # Get the list of backup items
    $backupItems = Get-ChildItem -Path $Path -Exclude '__BACKUPS__.csv'

    # Gather information about the backups
    $backupCount = $backupItems.Count
    $totalSize = $backupItems | Measure-Object -Sum Length | Select-Object -ExpandProperty Sum
    $lastBackup = $backupItems | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    # Show the status information
    $status = @{
        BackupCount    = $backupCount
        TotalSize      = $totalSize
        LastBackupDate = $lastBackup.LastWriteTime
        LastBackupPath = $lastBackup.FullName
    }

    Write-Output $status
}
