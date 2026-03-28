<#
.SYNOPSIS
    Returns a list of all screenshots
.DESCRIPTION
    Returns a list of all screenshots in the screenshot folder. The list can be filtered using the parameters of this function.
.EXAMPLE
    Get-Screenshot
    Returns the list of all screenshots
.EXAMPLE
    Get-Screenshot -Filter "*.png"
    Returns the list of all screenshots with the .png extension
.EXAMPLE
    Get-Screenshot -Last 5
    Returns the list of the last 5 screenshots
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
function Get-Screenshot {

    [CmdletBinding(DefaultParameterSetName = "All")]
    param (
        # The folder where the screenshots are stored
        [Parameter(ParameterSetName = "All")]
        [ValidateScript({ Test-Path -Path $_ })]
        [Alias("Folder", "Source", "FolderPath")]
        [string] $Path = $Script:ScreenshotFolder,

        # Filter the list of screenshots
        [Parameter(ParameterSetName = "All")]
        [string] $Filter,

        # Last n screenshots to return
        [Parameter(ParameterSetName = "All")]
        [Alias("Last", "Tail", "Take")]
        [int] $First,

        # Switch to get the latest screenshot
        [Parameter(ParameterSetName = "Latest")]
        [Alias("Newest", "MostRecent")]
        [switch] $Latest
    )

    # If the Latest parameter is specified, return the most recent screenshot
    if ($PSCmdlet.ParameterSetName -eq "Latest") {
        # Return the most recent screenshot
        return Get-ChildItem -Path $Path -Filter:$Filter -Recurse | Sort-Object -Property LastWriteTime | Select-Object -First 1
    }

    # Get the list of screenshots based on the specified parameters
    $Screenshots = Get-ChildItem -Path $Path -Filter:$Filter -Recurse
    if ($Last) {
        $Screenshots = $Screenshots | Sort-Object -Property LastWriteTime -Descending | Select-Object -First $Last
    }
    
    # Return the list of screenshots
    return $Screenshots
}
