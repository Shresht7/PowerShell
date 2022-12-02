<#
.SYNOPSIS
    Returns a list of all screenshots
.DESCRIPTION
    Returns a list of all screenshots
.EXAMPLE
    Get-Screenshot
    Returns the list of all screenshots
.EXAMPLE
    Get-Screenshot | Sort-Object -Property LastWriteTime | Select-Object -First 1 | Invoke-Item
    Opens the latest screenshot with the default application
#>
function Get-Screenshot(
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Folder = "$HOME\Pictures\Screenshots"
) {
    Get-ChildItem -Path $Folder
}
