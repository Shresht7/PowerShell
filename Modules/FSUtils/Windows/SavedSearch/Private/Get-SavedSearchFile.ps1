<#
.SYNOPSIS
    Gets a saved search file by name
.DESCRIPTION
    Returns the file matching the given name
#>
function Get-SavedSearchFile {
    param(
        [Alias('Search', 'SearchName')]
        [string] $Name
    )

    $files = Get-ChildItem -LiteralPath (Get-SavedSearchPath) -Filter '*.search-ms' -File

    if ($Name) {
        $files = $files.Where({ $_.BaseName -eq $Name })
    }

    $files
}
