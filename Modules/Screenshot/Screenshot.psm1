# Screenshot Folder
$Script:ScreenshotFolder = "$HOME\Pictures\Screenshots"

# Source all the public functions
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" | ForEach-Object { . $_.FullName }
