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
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    process {
        if ([string]::IsNullOrEmpty($Name)) {
            $Target = Get-LibraryPath
        }
        else {
            $File = Get-LibraryFile -Name $Name
            if (-not $File) {
                Write-Error "Library '$Name' not found"
                return
            }
            $Target = $File.FullName
        }

        Write-Verbose "Opening $Target"
        Start-Process explorer.exe -ArgumentList "`"$Target`""
    }

}
