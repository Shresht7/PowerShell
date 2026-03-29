<#
.SYNOPSIS
    Set the PSReadLine history contents
.DESCRIPTION
    Sets (overwrites) the contents of the PSReadLine history file. Useful after performing
    some manipulation on the existing history (using Get-PSReadLineHistory)
.EXAMPLE
    $History | Set-PSReadLineHistory
    Updates the PSReadLineHistory Contents with $History
.EXAMPLE
    Set-PSReadLineHistory -Content ($Content)
    Updates the PSReadLineHistory Contents with $Contents
.EXAMPLE
    Set-PSReadLineHistory -Content (Get-PSReadLineHistory | Where-Object { $_ -notmatch "Get-Service" })
    Removes all instances of the "Get-Service" command from the PSReadLine history.
.EXAMPLE
    Get-PSReadLineHistoryFrequency -Top 500 | Set-PSReadLineHistory
    Keeps the top 500 most frequently used commands in the history.
#>
function Set-PSReadLineHistory {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        # The new contents of the PSReadLine history file. Accepts strings or objects with a Command property.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Content,

        # If specified, appends to the history file instead of overwriting
        [switch] $Append
    )

    process {
        if ($Content -is [string]) {
            $command = $Content
        }
        elseif ($Content.PSObject.Properties.Name -contains 'Command') {
            $command = $Content.Command
        }
        else {
            $command = $Content.ToString()
        }

        $Path = Get-PSReadLineHistoryPath

        try {
            if ($Append) {
                $command | Add-Content -Path $Path
            }
            else {
                $Temp = "$Path.temp"
                $command | Out-File -FilePath $Temp
                Move-Item -Path $Temp -Destination $Path -Force
            }
        }
        catch {
            throw "Failed to write PSReadLine history file: $_"
        }
        finally {
            if (-not $Append -and (Test-Path $Temp)) {
                Remove-Item $Temp -Force
            }
        }
    }
}
