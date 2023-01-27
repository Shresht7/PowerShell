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
    [Alias("Folder", "Source", "FolderPath")]
    [string] $Path = $Script:ScreenshotFolder,

    # Filter the list of screenshots
    [string] $Filter
) {
    Get-ChildItem -Path $Path -Filter:$Filter -Recurse
}
