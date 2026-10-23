<#
.SYNOPSIS
    Reads a library definition file
.DESCRIPTION
    Reads the XML definition of a library file (*.library-ms)
#>
function Read-LibraryDefinition {
    param(
        # Name of the library to read
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    $File = Get-LibraryFile | Where-Object BaseName -eq $Name

    if (-not $File) {
        throw "Library '$Name' not found."
    }

    [xml](Get-Content $File.FullName -Raw)
}
