<#
.SYNOPSIS
    Resolves the full path of a saved search file
.DESCRIPTION
    Returns the full path of the saved search file
#>
function Resolve-SavedSearchPath {
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )    

    $file = Get-SavedSearchFile -Name $Name

    if (-not $file) {
        throw "Saved search '$Name' not found!"
    }

    $file.FullName
}
