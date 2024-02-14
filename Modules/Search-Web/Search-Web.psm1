# Search-Engines JSON file
$Script:SearchEnginesJsonFile = "$HOME\Data\searchEngines.json"

# If the Search-Engine JSON file exists, load the Search-Engine data
if (Test-Path -Path $Script:SearchEnginesJsonFile) {
    $Script:SearchEngines = Get-Content -Path $Script:SearchEnginesJsonFile | ConvertFrom-Json
}
# ... otherwise load the default data
else {
    $Script:SearchEngines = @(
        @{
            name     = "Google"
            shortcut = "google"
            url      = "https://google.com/search?q=%s"
        })
}

# Source Private Functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Source and Export Public Functions
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}
