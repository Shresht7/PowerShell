<#
.SYNOPSIS
    Draw a separator
.DESCRIPTION
    Draw a separator on the console.
.EXAMPLE
    Write-Separator
.EXAMPLE
    Write-Separator -Character "*"
    ******************************************************
.EXAMPLE
    Write-Separator -Character '-'
    ------------------------------------------------------
.EXAMPLE
    Write-Separator -Character '=' -Length 80
    ======================================================================
.EXAMPLE
    Write-Separator -Color $PSStyle.Foreground.Red
    Create a red colored separator
.EXAMPLE
    Write-Separator -Color $PSStyle.Foreground.Red, $PSStyle.Bold
    Create a separator that is red in color and bold
#>
function Write-Separator(
    # The character to use for the separator. (Defaults to "-")
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Symbol', 'Char')]
    [string] $Character = '-',

    # The number of times to repeat the character. (Defaults to the WindowSize.Width)
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [Alias('Length')]
    [int] $Width = $Host.UI.RawUI.WindowSize.Width,

    # The ansi color/style of the separator
    [Parameter(Position = 2)]
    [Alias('Color')]
    [string[]] $Style
) {
    # Create the separator
    $Separator = ($Character * $Width)

    # If a color/style has been passed, wrap it around the separator text
    if ($Style -and $Style.Length -gt 0) {
        $Style = $Style -join ""
        $Separator = $Style + ($Character * ($Width - 3)) + $PSStyle.Reset
    }

    # Draw the separator to the console
    Write-Host -Object $Separator
}
