<#
.SYNOPSIS
    Returns the path to various browser data files or directories.
.DESCRIPTION
    Retrieves the path for a specified browser and data type (Profile, Bookmarks, WebData).
.PARAMETER Browser
    The name of the browser (Edge, Chrome, etc).
.PARAMETER Type
    (Optional) The type of path to retrieve (Profile, Bookmarks, WebData).
.EXAMPLE
    Get-BrowserPath -Browser Edge -Type Bookmarks
.EXAMPLE
    Get-BrowserPath -Browser Chrome -Type WebData
#>
function Get-BrowserPath {
    param(
        # The name of the browser (Edge, Chrome, etc).
        [Parameter(Mandatory)]
        [ValidateSet("Edge", "Chrome")]
        [string] $Browser,

        # (Optional) The type of path to retrieve (Profile, Bookmarks, WebData).
        [Parameter(Mandatory = $false)]
        [ValidateSet("Profile", "Bookmarks", "WebData")]
        [string] $Type
    )

    $BasePath = switch ($Browser) {
        "Edge" { "$Env:LOCALAPPDATA\Microsoft\Edge\User Data\Default" }
        "Chrome" { "$Env:LOCALAPPDATA\Google\Chrome\User Data\Default" }
    }

    switch ($Type) {
        "Profile" { return $BasePath }
        "Bookmarks" { return Join-Path $BasePath "Bookmarks" }
        "WebData" { return Join-Path $BasePath "Web Data" }
        default { return $BasePath }
    }
}
