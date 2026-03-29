<#
.SYNOPSIS
    Clears old PSReadLine history backups
.DESCRIPTION
    Removes old backup files, keeping only the specified number of most recent backups.
    Only removes files matching the history backup pattern.
.EXAMPLE
    Clear-PSReadLineHistoryBackups
    Keeps the 10 most recent backups
.EXAMPLE
    Clear-PSReadLineHistoryBackups -Keep 5
    Keeps only the 5 most recent backups
#>
function Clear-PSReadLineHistoryBackups {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([int])]
    param (
        # Number of backups to keep. Default is 10.
        [ValidateRange(1, 100)]
        [int] $Keep = 10
    )

    $historyPath = Get-PSReadLineHistoryPath
    $dir = Split-Path $historyPath
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($historyPath) -replace '_history$', ''

    $pattern = "${baseName}_*"
    $backups = Get-ChildItem -Path $dir -Filter $pattern -File | Sort-Object LastWriteTime -Descending

    $toRemove = $backups | Select-Object -Skip $Keep

    $removedCount = 0
    foreach ($backup in $toRemove) {
        if ($PSCmdlet.ShouldProcess($backup.FullName)) {
            Remove-Item $backup.FullName -Force
            $removedCount++
        }
    }

    Write-Verbose "Removed $removedCount old backups, kept latest $Keep"
    return $removedCount
}