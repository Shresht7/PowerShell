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

    # Get the history path from PSReadLine options, or use env override for testing
    if ($env:PSREADLINE_HISTORY_PATH) {
        $historyPath = $env:PSREADLINE_HISTORY_PATH
    }
    else {
        $option = Get-PSReadLineOption -ErrorAction SilentlyContinue
        $historyPath = $option.HistorySavePath

        if (-not $historyPath) {
            $historyPath = Join-Path $env:USERPROFILE "PSReadLine_history.txt"
        }
    }

    # Validate the history path if it exists
    if ((Test-Path $historyPath -PathType Leaf) -eq $false -and -not $env:PSREADLINE_HISTORY_PATH) {
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
