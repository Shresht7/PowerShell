<#
.SYNOPSIS
    Tests if a library is a default library
.DESCRIPTION
    Checks against known default libraries
#>
function Test-DefaultLibrary {
    param([Parameter(Mandatory)][string] $Name)

    $defaults = @(
        'Camera Roll',
        'Documents',
        'Music',
        'Pictures',
        'SavedPictures',
        'Videos'
    )

    $leaf = (Split-Path -Leaf $Name) -replace '\.library-ms$', ''

    $defaults -contains $leaf
}
