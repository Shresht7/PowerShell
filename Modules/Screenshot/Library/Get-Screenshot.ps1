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
.EXAMPLE
    Get-Screenshot -Latest | Invoke-Item
    Opens the latest screenshot with the default application
#>
function Get-Screenshot(
    # The folder where the screenshots are stored
    [ValidateScript({ Test-Path -Path $_ })]
    [Alias("Folder", "Source", "FolderPath")]
    [string] $Path = $Script:ScreenshotFolder,

    # Filter the list of screenshots
    [string] $Filter,

    # Switch to get the latest screenshot
    [Parameter(ParameterSetName = "Latest")]
    [Alias("Newest", "MostRecent")]
    [switch] $Latest
) {

    # If the Latest parameter is specified, return the most recent screenshot
    if ($PSCmdlet.ParameterSetName -eq "Latest") {
        # Return the most recent screenshot
        return Get-ChildItem -Path $Path -Filter:$Filter -Recurse | Sort-Object -Property LastWriteTime | Select-Object -First 1
    }

    # Return the list of screenshots
    Get-ChildItem -Path $Path -Filter:$Filter -Recurse
}
