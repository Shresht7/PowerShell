<#
.SYNOPSIS
Sets the path of the screenshot folder.
.DESCRIPTION
The Set-ScreenshotFolder function allows you to specify and set the path of the screenshot folder.
.EXAMPLE
    Set-ScreenshotFolder -Path "C:\Screenshots"
    This example demonstrates how to use the Set-ScreenshotFolder function to set the path of the screenshot folder to "C:\Screenshots".
.INPUTS
    System.String
    This function accepts input through the pipeline or by specifying the Path parameter.
.OUTPUTS
    None
    This function does not generate any output. It updates the $Script:ScreenshotFolder variable with the specified path.
#>
function Set-ScreenshotFolder(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Folder")]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path
) {
    $Script:ScreenshotFolder = $Path
}
