# Import Private Functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}
