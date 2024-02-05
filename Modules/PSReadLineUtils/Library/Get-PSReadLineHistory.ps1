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
        $lineBlock = [System.Collections.ArrayList]@()

        # Read the history file line by line
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineHistoryPath))) {

            # If the line ends with a backtick, it's a continuation of the previous line
            if ($line.EndsWith('`')) {
                # Remove the backtick and add the line to the lineBlock variable
                $line = $line.SubString(0, $line.Length - 1)
                $lineBlock.Add($line) | Out-Null
                continue
            }

            # If the line does not end with a backtick, but we have an existing lineBlock,
            # then add the line to the lineBlock and join the lines together with a newline
            # and reset the lineBlock variable
            if ($lineBlock) {
                $lineBlock.Add($line) | Out-Null
                $line = $lineBlock -join "`n"
                $lineBlock = @()
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
