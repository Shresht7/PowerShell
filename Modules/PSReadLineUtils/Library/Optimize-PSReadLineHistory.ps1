<#
.SYNOPSIS
    Optimizes the PSReadLine history file
.DESCRIPTION
    The Optimize-PSReadLineHistory function removes duplicate items from
    the PSReadLine history and trims the history to a specified number of lines.
    Keeps the last (most recent) occurrence of each command while preserving execution order.
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
    [OutputType([void])]
    param (
        # The maximum number of lines to keep in the history file
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, 100000)]
        [Alias("MaxLines", "MaxCount", "MaxHistoryCount", "Count")]
        [uint] $MaxLineCount = 10000,

        # Skips creating a backup before making changes
        [switch] $NoBackup
    )

    # Get the PSReadLine history and remove duplicates (keeping last occurrence)
    $History = Get-PSReadLineHistory
    $StartingCount = $History.Count
    $lastIndex = @{}
    for ($i = 0; $i -lt $History.Count; $i++) {
        $lastIndex[$History[$i]] = $i
    }
    $History = for ($i = 0; $i -lt $StartingCount; $i++) {
        if ($lastIndex[$History[$i]] -eq $i) { $History[$i] }
    }
    $DuplicateCount = $StartingCount - @($History).Count
    if ($DuplicateCount -gt 0) {
        Write-Verbose -Message "Removed $DuplicateCount duplicate items from the PSReadLine history"
    }

    # If the history is larger than the maximum line count, remove the oldest items
    $ToRemoveCount = $History.Count - $MaxLineCount
    if ($ToRemoveCount -gt 0) {
        $History = $History | Select-Object -Skip $ToRemoveCount
        Write-Verbose -Message "Removed $ToRemoveCount oldest items from the PSReadLine history"
    }

    # Write the history back to the history file
    if ($PSCmdlet.ShouldProcess("Optimize PSReadLine History")) {
        $History -join "`n" | Set-PSReadLineHistory -NoBackup:$NoBackup
        Write-Verbose -Message "Optimized PSReadLine history file!"
    }

}
