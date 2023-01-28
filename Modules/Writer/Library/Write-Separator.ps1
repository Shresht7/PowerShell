<#
.SYNOPSIS
    Draw a separator
.DESCRIPTION
    Draw a separator on the console.
.EXAMPLE
    Write-Separator
.EXAMPLE
    Write-Separator -Character "*"
.EXAMPLE
    Write-Separator -Character '-'
.EXAMPLE
    Write-Separator -Character '=' -Length 80
#>
function Write-Separator(
    # The character to use for the separator
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Symbol', 'Char')]
    [string] $Character = '-',

    # The number of times to repeat the character
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [Alias('Length')]
    [int] $Width = $Host.UI.RawUI.WindowSize.Width
) {
    # Draw the separator
    Write-Host -Object ($Character * $Width)
}
