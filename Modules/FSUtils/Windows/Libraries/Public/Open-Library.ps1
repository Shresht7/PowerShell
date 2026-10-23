<#
.SYNOPSIS
    Opens a library in Explorer
.DESCRIPTION
    Opens a library in Explorer 
#>
function Open-Library {

    [CmdletBinding()]
    param(
        # The name of the library to open in Explorer
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Name
    )

    process {
        $Library = Get-LibraryFile $Name
        Write-Verbose "Opening '$($Library.FullName)' in Explorer"
        Start-Process explorer.exe $Library.FullName
    }

}
