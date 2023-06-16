# ----------------------
# Restore-ItemFromBackup
# ----------------------

<#
.SYNOPSIS
Restores an item from the backup.
.DESCRIPTION
Restores the most recent copy of the given item from the defined backup folder.
.PARAMETER Name
The item to restore.
.PARAMETER Path
The path to restore the item to.
.PARAMETER BackupPath
Path to the backup directory.
.PARAMETER Type
Specify the type of restoration: "Archive" or "Copy".
.EXAMPLE
Restore-Item README
Restores the most recent backup of the README to the current directory.
.EXAMPLE
Restore-Item -Name README -Path Git
Restores the most recent backup of the README to the `Git` folder.
#>

function Restore-ItemFromBackup {

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "HIGH")]
    Param (
        # The item to restore
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Item", "Input")]
        [string]$Name,
    
        # The path to restore the item to
        [Alias("Output", "DestinationPath")]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path = $PWD.Path,
    
        # Path to the backup directory
        [ValidateScript({ Test-Path $_ })]
        [string] $BackupPath = $Script:BACKUP_PATH,
    
        [ValidateSet("Archive", "Copy")]
        [string]$Type = "Archive"
    )

    # Get the most latest backup item
    $LatestBackupItem = Get-Backup -Filter *$Name* | Select-Object -First 1

    if (-Not $LatestBackupItem) {
        Write-Error "Failed to find any backups with matching criteria"
        return
    }

    # Resolve the destination path
    $Path = Resolve-Path -Path $Path

    # TODO: Select "Archive" or "Copy" based on the file extension

    # Check should process
    if (-Not $PSCmdlet.ShouldProcess($Path, "Restoring $($LatestBackupItem.Name)")) { return }

    # Restore Item to the Destination Path
    if ($Type -eq "Archive") {
        Expand-Archive -Path $LatestBackupItem -DestinationPath $Path -Force
    }
    if ($Type -eq "Copy") {
        $DestinationPath = Join-Path -Path $Path -ChildPath $LatestBackupItem.Name
        Copy-Item -Path $LatestBackupItem.FullName -Destination $DestinationPath -Force
    }
}
