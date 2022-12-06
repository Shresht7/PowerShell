# Import Dependencies
Import-Module -Name AutoComplete

# Import Helpers
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import Utilities
Get-ChildItem -Path "$PSScriptRoot\Utilities" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
