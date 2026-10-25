<#
.SYNOPSIS
    Returns the full path to a library file
.DESCRIPTION
    Resolves library paths to full .library-ms files
#>
function Resolve-LibraryPath {
    param([string] $Name)
    if ($Name -like '*.library-ms') { return $Name }
    Join-Path (Get-LibraryPath) "$Name.library-ms"
}
