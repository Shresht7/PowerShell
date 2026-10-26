<#
.SYNOPSIS
    Gets the path to the Searches folder
.DESCRIPTION
    Returns the full path to the Searches folder
.EXAMPLE
    Get-SavedSearchPath
    Returns the path to the current user's Searches folder.
#>
function Get-SavedSearchPath {
    $Path = Join-Path $Env:USERPROFILE 'Searches'

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "Searches folder not found: '$Path'"
    }

    $Path
}
