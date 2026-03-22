<#
.SYNOPSIS
    Gets a list of libraries
.DESCRIPTION
    Returns all the windows library folders
.EXAMPLE
    Get-Library
    Returns a directory listing of the libraries folder ($ENV:APPDATA\Microsoft\Windows\Libraries)
#>
function Get-Library() {
    Get-ChildItem -Path "$ENV:APPDATA\Microsoft\Windows\Libraries"
}
