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
    Opens the default library in Explorer
#>
function Open-Library {

    [CmdletBinding()]
    param(
        # The name of the library to open in Explorer
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Library
    )

    Write-Verbose $Library

    if ([string]::IsNullOrEmpty($Library)) {
        $Library = Get-LibraryPath
    }
    else {
        $Library = Get-LibraryFile $Library
    }

    if (-not (Test-Path -Path $Library)) {
        Write-Error "Invalid library path: $Library"
        return
    }

    Write-Verbose "Opening '$Library' in Explorer"
    Start-Process explorer.exe $Library

}
