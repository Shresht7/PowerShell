<#
.SYNOPSIS
    Returns a list of all screenshots
.DESCRIPTION
    Returns a list of all screenshots
.EXAMPLE
    Get-Screenshot
    Returns the list of all screenshots
.EXAMPLE
    Get-Screenshot | Invoke-Fzf | Invoke-Item
    Returns the list of all screenshots and opens the selected one
.EXAMPLE
    Get-Screenshot | Sort-Object -Property LastWriteTime | Select-Object -First 1 | Invoke-Item
    Opens the latest screenshot with the default application
#>
function Get-Screenshot(
    # The folder where the screenshots are stored
    [ValidateScript({ Test-Path -Path $_ })]
    [Alias("Folder", "Source", "FolderPath")]
    [string] $Path = $Script:ScreenshotFolder,

    # Filter the list of screenshots
    [string] $Filter
) {
    Get-ChildItem -Path $Path -Filter:$Filter -Recurse
}
