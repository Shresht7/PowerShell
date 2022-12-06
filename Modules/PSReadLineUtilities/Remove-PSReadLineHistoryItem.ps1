<#
.SYNOPSIS
    Removes one or more items from the PSReadLine history
.DESCRIPTION
    The Remove-PSReadLineHistoryItem function allows you to remove specific items from the PSReadLine history,
    or to remove the last few items from the history.
.EXAMPLE
    Remove-PSReadLineHistoryItem -Command "Get-Service"
    Removes all instances of the "Get-Service" command from the PSReadLine history.
.EXAMPLE
    Remove-PSReadLineHistoryItem -Command "Get-Service", "Get-Process"
    Removes all instances of the "Get-Service" and "Get-Process" commands from the PSReadLine history.
.EXAMPLE
    Get-Service | Remove-PSReadLineHistoryItem
    Removes all instances of the "Get-Service" command from the PSReadLine history.
.EXAMPLE
    Remove-PSReadLineHistoryItem -Count 10
    Removes the last 10 items from the PSReadLine history.
.INPUTS
    [string[]]
.OUTPUTS
    None
.NOTES
    By default, the Remove-PSReadLineHistoryItem function will prompt you to confirm before removing any items from the history.
    You can use the -Force parameter to suppress this confirmation.
#>
function Remove-PSReadLineHistoryItem {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Count")]
    param (
        # Specifies the items that you want to remove from the history.
        # This parameter supports wildcards, and you can specify multiple items by using a comma-separated list or by using the pipeline.
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "Command"
        )]
        [Alias("Name", "Item")]
        [string[]] $Command,

        # Specifies the number of items to remove from the end of the history. The default value is 1.
        [Parameter(ParameterSetName = "Count")]
        [Alias("Last", "Amount")]
        [uint] $Count = 1
    )

    begin {
        # Get the PSReadLineHistory
        $ReadlineHistory = Get-PSReadLineHistory
    }
	
    process {
        switch ($PSCmdlet.ParameterSetName) {
            "Command" {
                # Iterate over all items that are marked-for-removal and filter the ReadLineHistory
                foreach ($filter in $Command) {
                    $ReadlineHistory = $ReadlineHistory | Where-Object { $_ -cne $filter }
                }
            }
            "Count" {
                $Length = $PSReadLineHistory.Length
                $Mark = $Length - $Count
                # Get everything but the last $Count items (accounting for off-by-one and the current command itself)
                $PSReadLineHistory = $PSReadLineHistory[0..($Mark - 1)]
            }
        }
    }

    end {
        # Set Content of the PSReadLineHistory
        if ($PSCmdlet.ShouldProcess((Get-PSReadLineHistoryPath))) {
            Set-PSReadLineHistory $ReadlineHistory
        }
    }
}
