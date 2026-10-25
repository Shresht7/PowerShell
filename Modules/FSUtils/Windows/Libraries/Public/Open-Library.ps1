<#
.SYNOPSIS
    Opens a library in Explorer
.DESCRIPTION
    Opens a library in Explorer
.EXAMPLE
    Open-Library Documents
    Opens the Documents library in Explorer
.EXAMPLE
    Get-Library Pictures | Open-Library
    Opens the Pictures library in Explorer
.EXAMPLE
    Open-Library
    Opens the Windows Libraries folder
#>
function Open-Library {

    [CmdletBinding()]
    param(
        # The name of the library to open in Explorer
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Library
    )

    process {
        $Target = if ([string]::IsNullOrEmpty($Library)) {
            Get-LibraryPath
        }
        else {
            (Get-LibraryFile -Name $Library).FullName
        }

        if (-not (Test-Path -LiteralPath $Target)) {
            Write-Error "Invalid Library Path: $Target"
            return
        }

        Write-Verbose "Opening $Target"
        Start-Process explorer.exe $Target
    }

}
