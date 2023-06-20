# Screenshot Folder
$Script:ScreenshotFolder = "$HOME\Pictures\Screenshots"

function Get-ScreenshotFolder() {
    return $Script:ScreenshotFolder
}

function Set-ScreenshotFolder(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Folder")]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path
) {
    $Script:ScreenshotFolder = $Path
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
