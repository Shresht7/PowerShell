# Search-Engines JSON file
$Script:SearchEnginesJsonFile = "$HOME\Data\searchEngines.json"

# Search-Engines Data
$Script:SearchEngines = Get-Content -Path $Script:SearchEnginesJsonFile | ConvertFrom-Json

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
