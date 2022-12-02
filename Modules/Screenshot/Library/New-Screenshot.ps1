<#
.SYNOPSIS
    Capture a screenshot
.DESCRIPTION
    Captures a screenshot and save it on disk
.EXAMPLE
    New-Screenshot
    Captures a screenshot and saves it to the screenshot folder
.EXAMPLE
    New-Screenshot -Open
    Captures a screenshot and opens it with default application
#>
function New-Screenshot(
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Folder = "$HOME\Pictures\Screenshots",

    # Open the screenshot
    [switch] $Open
) {
    Add-Type -AssemblyName System.Windows.Forms

    $FilePath = Join-Path $Folder "Screenshot_$(Get-Date -Format FileDateTimeUniversal).png"

    $VirtualScreen = [Windows.Forms.SystemInformation]::VirtualScreen
    $ScreenshotBitmap = New-Object -TypeName Drawing.Bitmap $VirtualScreen.Width, $VirtualScreen.Height
    $ScreenshotGraphics = [Drawing.Graphics]::FromImage($ScreenshotBitmap)

    $ScreenshotGraphics.CopyFromScreen($VirtualScreen.Location, [Drawing.Point]::Empty, $VirtualScreen.Size)
    $ScreenshotGraphics.Dispose()

    $ScreenshotBitmap.Save($FilePath)
    $ScreenshotBitmap.Dispose()

    if ($Open) {
        Invoke-Item -Path $FilePath
    }
}
