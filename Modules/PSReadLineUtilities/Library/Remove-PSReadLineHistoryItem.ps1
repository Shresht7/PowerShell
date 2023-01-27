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
    [string]
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
        [string] $Command,

        # Specifies the number of items to remove from the end of the history. The default value is 1.
        [Parameter(ParameterSetName = "Count")]
        [Alias("Last", "Amount")]
        [uint] $Count = 1,

        # Removes duplicate items
        [Parameter(ParameterSetName = "Duplicate")]
        [switch] $Duplicate
    )

    begin {
        # Get the PSReadLineHistory
        $PSReadLineHistory = Get-PSReadLineHistory
    }
	
    process {
        switch ($PSCmdlet.ParameterSetName) {
            "Command" {
                # Iterate over all items that are marked-for-removal and filter the ReadLineHistory
                $PSReadLineHistory = $PSReadLineHistory | Where-Object { $_ -cne $filter }
                Write-Verbose "$($Command.Count) commands removed!"
                break
            }
            "Count" {
                $Length = $PSReadLineHistory.Length
                $Mark = $Length - $Count
                # Get everything but the last $Count items (accounting for off-by-one and the current command itself)
                $PSReadLineHistory = $PSReadLineHistory[0..($Mark - 1)]
                Write-Verbose "$Mark commands removed!"
                break
            }
            "Duplicate" {
                $originalCount = ($PSReadLineHistory | Measure-Object -Line).Lines
                $PSReadLineHistory = $PSReadLineHistory | Sort-Object -Unique
                $finalCount = ($PSReadLineHistory | Measure-Object -Line).Lines
                $diffCount = $originalCount - $finalCount
                Write-Verbose "$diffCount duplicate commands removed!"
                break
            }
        }
    }

    end {
        # Join the PSReadLineHistory back into a single string
        $PSReadLineHistory = $PSReadLineHistory -join "`n"
        # Set Content of the PSReadLineHistory
        if ($PSCmdlet.ShouldProcess((Get-PSReadLineHistoryPath))) {
            Set-PSReadLineHistory -Content $PSReadLineHistory
        }
    }
}

# Removes the currently selected command from the PSReadLineHistory
Set-PSReadLineKeyHandler -Key Ctrl+Shift+K `
    -BriefDescription "Removes the item from the console and the PSReadLineHistory" `
    -ScriptBlock {
    param ($Key, $Arg)

    $Line = $null
    $Cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

    Remove-PSReadLineHistoryItem -Command $Line
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
}
