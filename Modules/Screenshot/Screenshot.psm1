# Screenshot Folder
$Script:ScreenshotFolder = "$HOME\Pictures\Screenshots"

# Source and Export Public Functions
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}
