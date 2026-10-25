<#
.SYNOPSIS
    Writes a status message
.DESCRIPTION
    Shows a status message in the console with color based on status type.
.EXAMPLE
    Write-StatusMessage -Message "All good" -Status "OK"
.EXAMPLE
    Write-StatusMessage -Message "Warning" -Status "WARN"
.EXAMPLE
    Write-StatusMessage -Message "Error" -Status "ERROR"
.EXAMPLE
    Write-StatusMessage -Message "Critical" -Status "CRITICAL"
#>
function Write-StatusMessage {

    [CmdletBinding()]
    param(
        # Message to display
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Message,

        # Text to display inside the brackets
        [string] $Status = 'INFO',

        # ANSI style for the status text
        [string] $StatusColor,

        # ANSI style for the message text
        [string] $MessageColor = ''
    )

    begin {
        $DefaultStatusColors = @{
            INFO     = $PSStyle.Foreground.Cyan
            ERROR    = $PSStyle.Foreground.Red
            WARN     = $PSStyle.Foreground.Yellow
            WARNING  = $PSStyle.Foreground.Yellow
            CRITICAL = "$($PSStyle.Foreground.Red)$($PSStyle.Bold)"
            SUCCESS  = $PSStyle.Foreground.Green
            OK       = $PSStyle.Foreground.Green
        }
    }

    process {
        if (-not $PSBoundParameters.ContainsKey('StatusColor')) {
            $StatusColor = $DefaultStatusColors[$Status.ToUpperInvariant()]
        }

        $StatusReset = if ($StatusColor) { $PSStyle.Reset } else { '' }
        $MessageReset = if ($MessageColor) { $PSStyle.Reset } else { '' }
        $Prefix = "$StatusColor[$Status]$StatusReset"
        $StyledMessage = "$MessageColor$Message$MessageReset"

        Write-Host "$Prefix $StyledMessage"
    }

}
