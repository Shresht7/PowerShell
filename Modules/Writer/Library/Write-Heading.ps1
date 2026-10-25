<#
.SYNOPSIS
    Writes a heading with optional formatting
.DESCRIPTION
    This function writes a heading with lines and optional uppercase text and double lines.
.EXAMPLE
    Write-Heading "Title"
.EXAMPLE
    Write-Heading "Title" -Double
.EXAMPLE
    Write-Heading "Title" -Uppercase -Double
.EXAMPLE
    Write-Heading "Title" -Character '*' -Double
#>
function Write-Heading {

    [CmdletBinding()]
    param(
        # Text to display as heading
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Text,

        # Character to use for lines
        [Alias('Char', 'Symbol')]
        [string] $Character = '=',

        # Width of the line (defaults to text length)
        [ValidateRange(1, [uint32]::MaxValue)]
        [uint32] $Width,

        # Uppercase the text if set
        [switch] $Uppercase,

        # Double lines if set
        [switch] $Double
    )

    process {
        if (-not ($PSBoundParameters.ContainsKey('Width'))) {
            $Width = $Text.Length
        }

        if ($Uppercase) { $Text = $Text.ToUpper() }

        if ($Double) { Write-Host ($Character * $Width) }
        Write-Host $Text
        Write-Host ($Character * $Width)
    }

}
