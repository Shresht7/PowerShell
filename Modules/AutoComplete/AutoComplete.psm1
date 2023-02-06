# Import Class
Get-ChildItem -Path "$PSScriptRoot\Class" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}
