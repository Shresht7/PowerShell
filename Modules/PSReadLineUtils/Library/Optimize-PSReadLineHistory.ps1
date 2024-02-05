<#
.SYNOPSIS
    Optimizes the PSReadLine history file
.DESCRIPTION
    The Optimize-PSReadLineHistory function removes duplicate items from the PSReadLine history and trims the history to a specified number of lines.
    This function is useful for keeping the history file small and efficient. 
    By default, the history file is limited to 10,000 lines.
.EXAMPLE
    Optimize-PSReadLineHistory
    Removes duplicate items from the PSReadLine history and trims the history to 10,000 lines.
.EXAMPLE
    Optimize-PSReadLineHistory -MaxLineCount 1000
    Removes duplicate items from the PSReadLine history and trims the history to 1,000 lines.
#>
function Optimize-PSReadLineHistory {
    
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The maximum number of lines to keep in the history file
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, 100000)]
        [Alias("MaxLines", "MaxCount", "MaxHistoryCount", "Count")]
        [uint] $MaxLineCount = 10000
    )

    # Get the PSReadLine history 
    $History = Get-PSReadLineHistory

    # Remove duplicate items from the history
    $History = $History | Select-Object -Unique

    # If the history is larger than the maximum line count, remove the oldest items
    $Count = $History.Count - $MaxLineCount
    if ($Count -gt 0) {
        $History = $History | Select-Object -Skip $Count
    }

    # Write the history back to the history file
    if ($PSCmdlet.ShouldProcess("Optimize PSReadLine History")) {
        $History | Set-PSReadLineHistory
        Write-Verbose -Message "Optimized PSReadLine history file!"
    }

}
