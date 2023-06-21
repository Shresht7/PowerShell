# Search-Engines JSON file
$Script:SearchEnginesJsonFile = "$PSScriptRoot\searchEngines.json"

# Search-Engines Data
$Script:SearchEngines = Get-Content -Path $Script:SearchEnginesJsonFile | ConvertFrom-Json

# Source Private Functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Source and Export Public Functions
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}
