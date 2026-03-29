<#
.SYNOPSIS
    Gets the frequency of the commands in the history
.DESCRIPTION
    Returns objects containing commands from the PSReadLine history and their usage count
.EXAMPLE
    Get-PSReadLineHistoryFrequency
    Returns objects containing commands from the PSReadLine history and their usage count
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
