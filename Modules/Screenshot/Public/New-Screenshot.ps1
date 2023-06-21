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
    # The path to the screenshot folder
    [Alias('Path', 'Destination', 'DestinationFolder', 'Target')]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Folder = $Script:ScreenshotFolder,

    # The screenshot's filename
    [Alias('Item', 'File', 'Screenshot')]
    [string] $Name,

    # Open the screenshot
    [switch] $Open
) {
    # Import Windows Forms
    Add-Type -AssemblyName System.Windows.Forms

    # Determine FilePath
    $FileName = $Name -or "Screenshot_$(Get-Date -Format FileDateTimeUniversal).png"
    $FilePath = Join-Path -Path $Folder -ChildPath $FileName

    # Capture Graphics
    $VirtualScreen = [Windows.Forms.SystemInformation]::VirtualScreen
    $ScreenshotBitmap = New-Object -TypeName Drawing.Bitmap $VirtualScreen.Width, $VirtualScreen.Height
    $ScreenshotGraphics = [Drawing.Graphics]::FromImage($ScreenshotBitmap)
    $ScreenshotGraphics.CopyFromScreen($VirtualScreen.Location, [Drawing.Point]::Empty, $VirtualScreen.Size)
    $ScreenshotGraphics.Dispose()

    # Save to Disk
    $ScreenshotBitmap.Save($FilePath)
    $ScreenshotBitmap.Dispose()

    # If the `-Open` switch is passed, open the screenshot
    if ($Open) {
        Invoke-Item -Path $FilePath
    }
}
