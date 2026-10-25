<#
.SYNOPSIS
    Returns the full path to a library file
.DESCRIPTION
    Resolves library paths to full .library-ms files
#>
function Resolve-LibraryPath {
    
    param([string] $Name)
    
    $path = if ($Name -like '*.library-ms') {
        $Name 
    }
    else {
        Join-Path (Get-LibraryPath) "$Name.library-ms"
    }
    
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Library not found: $path"
    }

    $path
}
