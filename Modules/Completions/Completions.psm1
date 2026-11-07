# Import and run all completer scripts
Get-ChildItem -Path $PSScriptRoot\Completers -Filter *.ps1 -Recurse | ForEach-Object {
    . $_.FullName
    Write-Verbose "Loaded $($_.Name)"
}
