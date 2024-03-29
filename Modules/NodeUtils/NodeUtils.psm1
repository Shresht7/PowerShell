# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import AutoComplete
. $PSScriptRoot\AutoComplete.ps1
