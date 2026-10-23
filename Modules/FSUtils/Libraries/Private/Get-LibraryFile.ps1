<#
.SYNOPSIS
    Gets the library files in the Libraries folder
.DESCRIPTION
    Returns all .library-ms files in the Libraries folder
#>
function Get-LibraryFile {
    Get-ChildItem -Path (Get-LibraryPath) -Filter '*.library-ms'
}
