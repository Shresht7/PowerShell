<#
.SYNOPSIS
    Returns the contents of the PSReadLine history file
.DESCRIPTION
    Returns the contents of the PSReadLine history file.
.EXAMPLE
    Get-PSReadLineHistory
    Returns the contents of the PSReadLine history file.
#>
function Get-PSReadLineHistory {
    $History = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''

        # Read the history file line by line
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineHistoryPath))) {

            # If the line ends with a backtick, it's a continuation of the previous line
            if ($line.EndsWith('`')) {
                # Remove the backtick and add the line to the list of lines
                $line = $line.SubString(0, $line.Length - 1)
                # If this is the first line, just set the lines variable
                $lines = if (!$lines) {
                    $line
                }
                # Otherwise, add the line to the list of lines
                else {
                    "$lines`n$line"
                }
                continue
            }

            # If there are lines, add the current line to the list of lines
            if ($lines) {
                $line = "$lines`n$line"
                $lines = '' # Reset the lines variable
            }
    
            # If the line is not the same as the last line, add it to the history
            if ($line -ne $last) {
                $last = $line
                $line
            }
        }    
    )
    return $History
}
