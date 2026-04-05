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
    Get-PSReadLineHistory | Where-Object { $_ -match "secret" } | Remove-PSReadLineHistoryItem
    Removes all commands matching "secret" from the PSReadLine history.
.EXAMPLE
    Remove-PSReadLineHistoryItem -Count 10
    Removes the last 10 items from the PSReadLine history.
.INPUTS
    [string]
.OUTPUTS
    None
.NOTES
    By default, the Remove-PSReadLineHistoryItem function will prompt you to confirm before removing any items from the history.
    You can use the -Force parameter to suppress this confirmation.
#>
function Remove-PSReadLineHistoryItem {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Count")]
    [OutputType([void])]
    param (
        # Specifies the items that you want to remove from the history.
        # You can specify multiple items by using a comma-separated list or by using the pipeline.
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            ParameterSetName = "Command"
        )]
        [Alias("Name", "Item")]
        [string] $Command,

        # Specifies the number of items to remove from the end of the history. The default value is 1.
        [Parameter(ParameterSetName = "Count")]
        [Alias("Last", "Amount")]
        [uint32] $Count = 1,

        # Removes duplicate items
        [Parameter(ParameterSetName = "Duplicate")]
        [switch] $Duplicate,

        # Skips creating a backup before making changes
        [switch] $NoBackup
    )

    begin {
        $commandsToRemove = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq "Command") {
            $commandsToRemove.Add($Command) | Out-Null
        }
    }

    end {
        $history = Get-PSReadLineHistory

        switch ($PSCmdlet.ParameterSetName) {
            "Command" {
                $history = $history | Where-Object { -not $commandsToRemove.Contains($_) }
            }
            "Count" {
                $history = $history | Select-Object -SkipLast $Count
            }
            "Duplicate" {
                $history = $history | Select-Object -Unique
            }
        }

        if ($PSCmdlet.ShouldProcess((Get-PSReadLineHistoryPath))) {
            $history | Set-PSReadLineHistory -NoBackup:$NoBackup
        }
    }
}
