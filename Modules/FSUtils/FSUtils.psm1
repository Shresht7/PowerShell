# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName -Force -Verbose
}
