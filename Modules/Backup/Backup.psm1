# The Default Backup Location
$Script:BACKUP_PATH = "$HOME\Archives\Backups"

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
