# Import Class
Get-ChildItem -Path "$PSScriptRoot\Class" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}

# Import Helpers
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}

# Import Commands
Get-ChildItem -Path "$PSScriptRoot\Commands" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
