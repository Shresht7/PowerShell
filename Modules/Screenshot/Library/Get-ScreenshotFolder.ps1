<#
.SYNOPSIS
    Retrieves the path of the screenshot folder.
.DESCRIPTION
    The Get-ScreenshotFolder function returns the path of the screenshot folder.
.EXAMPLE
    Get-ScreenshotFolder
    This example demonstrates how to use the Get-ScreenshotFolder function to retrieve the path of the screenshot folder.
.OUTPUTS
    System.String
    This function returns a string representing the path of the screenshot folder.
.NOTES
    The $Script:ScreenshotFolder variable must be set before using this function.
#>
function Get-ScreenshotFolder() {
    return $Script:ScreenshotFolder
}
