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
    $frequency = @{}
    foreach ($line in Get-PSReadLineHistory) {
        if (!$frequency[$line]) {
            $frequency.Add($line, 1)
        }
        else {
            $frequency[$line]++
        }
    }
    $sorted = $frequency.GetEnumerator() | Sort-Object -Property Value
    Write-Output $sorted
}
