<#
.SYNOPSIS
    Remove commands from the PSReadLine history
.DESCRIPTION
    Removes the selected commands and updates the PSReadLine history. If no arguments are passed, opens a 
    multi-select fzf input that you can use to choose the commands. Any and all commands that match any of
    the selection will be removed from the PSReadLine history.
.EXAMPLE
    Remove-PSReadLineHistoryItems -Command "git add ."
    Removes the "git add ." command from the history
#>
function Remove-PSReadLineHistoryItem {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Items that you want to remove from the history
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Name", "Item")]
        [string[]] $Command
    )

    begin {
        # Get the PSReadLineHistory
        $ReadlineHistory = Get-PSReadLineHistory
    }
	
    process {
        # Iterate over all items that are marked-for-removal and filter the ReadLineHistory
        foreach ($filter in $Command) {
            $ReadlineHistory = $ReadlineHistory | Where-Object { $_ -cne $filter }
        }
    }

    end {
        # Set Content of the PSReadLineHistory
        if ($PSCmdlet.ShouldProcess((Get-PSReadLineHistoryPath))) {
            Set-PSReadLineHistory $ReadlineHistory
        }
    }
}
