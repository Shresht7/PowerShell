<#
.SYNOPSIS
    Gets the frequency of the commands in the history
.DESCRIPTION
    Returns a hash-table containing commands from the PSReadLine history and the number of times they've been used
.EXAMPLE
    Get-PSReadLineHistoryFrequency
    Returns a hash-table containing commands from the PSReadLine history and their usage frequency
#>
function Get-PSReadLineHistoryFrequency {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        # If specified, only returns the top N most frequently used commands. Can also be specified using the alias -Top.
        [Alias('Top')]
        [int] $First,

        # The property to sort the results by. Can be either 'Count' or 'Name'. Defaults to 'Count'.
        [string] $SortBy = 'Count'
    )

    $Result = Get-PSReadLineHistory | Group-Object | Sort-Object -Property $SortBy -Descending
    if ($First) {
        $Result = $Result | Select-Object -Property Count, Name -First $First
    }
    $Result | Select-Object -Property Count, Name
}
