<#
.SYNOPSIS
    Gets the broken links
.DESCRIPTION
    Gets the broken links (that do not point to a valid location) in the given directory.
.EXAMPLE
    Get-BrokenSymlinks
    Returns a list of broken symlinks
.EXAMPLE
    Get-BrokenSymlinks | Remove-Item -Confirm
    Removes all broken symlinks asking as you go
#>
function Get-BrokenSymlinks(
    # The path to look inside of
    [ValidateScript({ Test-Path -Path $Path })]
    [string]$Path = ".",

    # Search recursively
    [switch]$Recurse
) {
    # Recursively get all children and filter out links. Then filter the links again to those who do not have a valid link target
    Get-ChildItem -Path $Path -Recurse:$Recurse | Where-Object { $null -ne $_.LinkTarget -And -Not (Test-Path -Path $_.LinkTarget) }
}
