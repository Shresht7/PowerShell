# Screenshot Folder
$Script:ScreenshotFolder = "$HOME\Pictures\Screenshots"

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
