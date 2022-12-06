<#
.SYNOPSIS
    Get the PSReadLine history contents
.DESCRIPTION
    Returns the contents of the PSReadLine history file
.EXAMPLE
    Get-PSReadLineHistory
    Returns the content of the PSReadLine history file
#>
function Get-PSReadLineHistory { Get-Content (Get-PSReadLineHistoryPath) }
