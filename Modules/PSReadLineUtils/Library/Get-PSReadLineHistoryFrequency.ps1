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
    # Variable to track the frequency of each command
    $frequency = @{}

    # Iterate over the history
    foreach ($line in Get-PSReadLineHistory) {
        # If the command is already in the hash-table, increment the count
        if (!$frequency[$line]) {
            $frequency.Add($line, 1)
        }
        # Otherwise, add the command to the hash-table
        else {
            $frequency[$line]++
        }
    }

    # Return the hash-table
    $frequency.GetEnumerator() | Sort-Object -Property Value
}
