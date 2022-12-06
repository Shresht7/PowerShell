<#
.SYNOPSIS
    Get the path to the PSReadLine history file
.DESCRIPTION
    Returns the path to the PSReadLine history file
.EXAMPLE
    Get-PSReadLineHistoryPath
    Returns the path to the PSReadLine history file
.EXAMPLE
    code (Get-PSReadLineHistoryPath)
    Opens the PSReadLine history file with VS Code
.EXAMPLE
    Set-Location (Split-Path (Get-PSReadLineHistoryPath))
    Set-Location to parent folder of the PSReadLine history file
#>
function Get-PSReadLineHistoryPath { (Get-PSReadLineOption).HistorySavePath }
