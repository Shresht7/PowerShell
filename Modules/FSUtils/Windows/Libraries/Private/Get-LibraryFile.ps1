<#
.SYNOPSIS
    Gets library file(s) from the Libraries folder and current location
.DESCRIPTION
    Gets library files from the Windows Libraries folder and the current location
    If a name is provided, only that library is returned.
.EXAMPLE
    Get-LibraryFile
    Returns all library files
.EXAMPLE
    Get-LibraryFile Documents
    Returns the Documents.library-ms file
#>
function Get-LibraryFile {
    param(
        # The name of the library to get (optional)
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    # Get all library files (*.library-ms) from the Windows Libraries folder and the current location
    $libraryFiles = Get-ChildItem -LiteralPath (Get-LibraryPath), (Get-Location) -Filter '*.library-ms'

    # Filter by name if provided
    if ($Name) {
        $libraryFiles = $libraryFiles.Where({ $_.BaseName -eq $Name })
    }

    # Return the library files
    $libraryFiles
}
