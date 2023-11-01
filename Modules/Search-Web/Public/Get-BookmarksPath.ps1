<#
.SYNOPSIS
    Returns the path to the Bookmarks file
.DESCRIPTION
    Returns the path to the source Bookmarks file
#>
function Get-BookmarksPath(
    # Name of the browser (defaults to Microsoft Edge)
    [ValidateSet("Edge")]
    [string] $Browser = "Edge"
) {
    switch ($Browser) {
        "Edge" { "$Env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks" }
        Default {}
    }
}
