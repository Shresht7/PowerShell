<#
.SYNOPSIS
    Creates a backup of the PSReadLine history file
.DESCRIPTION
    Creates a backup copy of the PSReadLine history file with a timestamp.
    Useful for preserving history before making changes. Optionally prunes old backups.
.EXAMPLE
    Backup-PSReadLineHistory
    Creates a backup of the history file in the same directory.
.EXAMPLE
    Backup-PSReadLineHistory -Destination "C:\Backups\my-history.txt"
    Creates a backup with a custom destination path.
.EXAMPLE
    Backup-PSReadLineHistory -Keep 5
    Creates a backup and removes old backups, keeping only 5
#>
function Backup-PSReadLineHistory {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Optional custom destination path. If not specified, creates a backup in the history directory.
        [string] $Destination,

        # Number of backups to keep. If specified, removes old backups.
        [ValidateRange(1, 100)]
        [int] $Keep
    )

    $Path = Get-PSReadLineHistoryPath

    if (-not $Destination) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $base = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        $ext = [System.IO.Path]::GetExtension($Path)
        $dir = [System.IO.Path]::GetDirectoryName($Path)
        $Destination = Join-Path $dir "${base}_${timestamp}${ext}"
    }

    Copy-Item -Path $Path -Destination $Destination -Force
    Write-Verbose "Backed up PSReadLine history to: $Destination"

    if ($Keep) {
        Clear-PSReadLineHistoryBackups -Keep $Keep
    }

    return $Destination
}