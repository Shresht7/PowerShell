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
    [OutputType([void])]
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
        [uint32] $Count = 1,

        # Removes duplicate items
        [Parameter(ParameterSetName = "Duplicate")]
        [switch] $Duplicate
    )

process {
        $history = Get-PSReadLineHistory

        switch ($PSCmdlet.ParameterSetName) {
            "Command" {
                $history = $history | Where-Object { $_ -ne $Command }
            }
            "Count" {
                $history = $history | Select-Object -SkipLast $Count
            }
            "Duplicate" {
                $history = $history | Select-Object -Unique
            }
        }

        if ($PSCmdlet.ShouldProcess((Get-PSReadLineHistoryPath))) {
            $history -join "`n" | Set-PSReadLineHistory
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

    # Remove the item from the PSReadLineHistory
    Remove-PSReadLineHistoryItem -Command $Line

    # Remove the item from the prompt
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()

    # Accept the empty line and move the prompt forward
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()

    # Write to the console that the item was removed
    Write-Host -ForegroundColor Red "Removed '$Line' from the PSReadLineHistory"

}
