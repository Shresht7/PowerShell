# Commands Global Variable (Tree) - This is the root of the tree object that holds all the commands and their completions
$Script:COMMANDS = @{ Completions = [System.Collections.ArrayList]::new() }

# Import Class
Get-ChildItem -Path "$PSScriptRoot\Class" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
