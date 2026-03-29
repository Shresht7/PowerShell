<#
.SYNOPSIS
    Get the path to the PSReadLine history file
.DESCRIPTION
    Returns the path to the PSReadLine history file
.EXAMPLE
    Get-PSReadLineHistoryPath
    Returns the path to the PSReadLine history file
.EXAMPLE
    Get-PSReadLineHistoryPath -Type Directory
    Returns the path to the parent directory of the PSReadLine history file
.EXAMPLE
    code (Get-PSReadLineHistoryPath)
    Opens the PSReadLine history file with VS Code
.EXAMPLE
    Get-PSReadLineHistoryPath -Type Directory | Set-Location
    Set-Location to parent folder of the PSReadLine history file
#>
function Get-PSReadLineHistoryPath {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # The type of path to return. 'File' returns the full path to the history file,
        # while 'Directory' returns the parent directory of the history file.
        [Parameter()]
        [ValidateSet('File', 'Directory')]
        [string] $Type = 'File'
    )

    # Get the history path from PSReadLine options
    $historyPath = (Get-PSReadLineOption).HistorySavePath

    # Validate the history path. It should be a valid file path.
    if (-not $historyPath -or (Test-Path $historyPath -PathType Leaf) -eq $false) {
        throw "PSReadLine history path is not set or invalid. Please check the HistorySavePath option in PSReadLine."
    }

    # Return the appropriate path based on the specified type
    switch ($Type) {
        'Directory' {
            return (Split-Path $historyPath)
        }
        'File' {
            return $historyPath
        }
    }
}
