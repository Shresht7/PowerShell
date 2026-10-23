<#
.SYNOPSIS
    Gets library file(s) from the Libraries folder.
.DESCRIPTION
    Gets library files from the Windows Libraries folder.
    If a name is provided, only that library is returned.
#>
function Get-LibraryFile {
    param(
        # The name of the library to get (optional)
        [string] $Name
    )

    # Get all library files (*.library-ms) from the Windows Libraries folder
    $libraryFiles = Get-ChildItem -Path (Get-LibraryPath) -Filter '*.library-ms'

    # Filter by name if provided
    if ($Name) {
        $libraryFiles = $libraryFiles | Where-Object { $_.BaseName -eq $Name }
    }

    # Return the library files
    $libraryFiles
}
