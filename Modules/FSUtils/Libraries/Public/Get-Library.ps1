<#
.SYNOPSIS
    Gets all the Windows libraries
.DESCRIPTION
    Returns all the libraries with their full paths
#>
function Get-Library {
    Get-LibraryFile | Select-Object @{N = 'Name'; E = { $_.BaseName } }, FullName
}
