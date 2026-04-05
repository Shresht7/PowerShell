<#
.SYNOPSIS
    Set the PSReadLine history contents
.DESCRIPTION
    Sets (overwrites) the contents of the PSReadLine history file. Multi-line commands
    are properly encoded using PSReadLine's backtick continuation format.
    Accepts pipeline input — all items are collected and written at once.
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
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        # The new contents of the PSReadLine history file. Accepts strings or objects with a Command property.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Content,

        # If specified, appends to the history file instead of overwriting
        [switch] $Append,

        # If specified, skips creating a backup before making changes
        [switch] $NoBackup
    )

    begin {
        $commands = [System.Collections.Generic.List[string]]::new()
    }

    process {
        if ($Content -is [string]) {
            $commands.Add($Content)
        }
        elseif ($Content.PSObject.Properties.Name -contains 'Command') {
            $commands.Add($Content.Command)
        }
        else {
            $commands.Add($Content.ToString())
        }
    }

    end {
        $Path = Get-PSReadLineHistoryPath

        if ($PSCmdlet.ShouldProcess($Path)) {
            if (-not $NoBackup -and -not $Append) {
                Backup-PSReadLineHistory
            }

            # Encode multi-line commands using PSReadLine's backtick continuation format:
            # internal newlines are replaced with (backtick + newline)
            $encodedLines = foreach ($cmd in $commands) {
                $cmd.Replace("`n", "``" + "`n")
            }

            try {
                if ($Append) {
                    $encodedLines | Add-Content -Path $Path
                }
                else {
                    $Temp = "$Path.temp"
                    $encodedLines | Out-File -FilePath $Temp
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
}
