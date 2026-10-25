# -------
# IMPORTS
# -------


Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# Windows Libraries
. "$PSScriptRoot\Libraries\Initialize-Libraries.ps1"
. "$PSScriptRoot\SavedSearch\Initialize-SavedSearch.ps1"
