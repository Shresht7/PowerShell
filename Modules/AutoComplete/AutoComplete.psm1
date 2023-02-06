# Import Class
Get-ChildItem -Path "$PSScriptRoot\Class" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
