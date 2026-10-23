<#
.SYNOPSIS
    Reads a library definition
.DESCRIPTION
    Reads the XML definition of a library
#>
function Read-LibraryDefinition {
    param(
        # Name of the library to read
        [Parameter(Mandatory)]
        [string] $LibraryName
    )

    $File = Get-LibraryFile | Where-Object BaseName -eq $LibraryName

    if (-not $File) {
        throw "Library '$LibraryName' not found."
    }

    [xml](Get-Content $File.FullName -Raw)
}
