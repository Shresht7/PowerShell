<#
.SYNOPSIS
    Returns the path to the Bookmarks file.
.DESCRIPTION
    Returns the path to the source Bookmarks file for the specified browser.
.PARAMETER Browser
    The name of the browser (defaults to Microsoft Edge).
.EXAMPLE
    Get-BookmarksPath -Browser "Chrome"
#>
function Get-BookmarksPath {
    param(
        # Name of the browser (defaults to Microsoft Edge)
        [ValidateSet("Edge", "Chrome")]
        [string] $Browser = "Edge"
    )

    Get-BrowserPath -Browser $Browser -Type Bookmarks
}
