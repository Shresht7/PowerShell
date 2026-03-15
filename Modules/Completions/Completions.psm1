# Import and run all completer scripts
Get-ChildItem -Path $PSScriptRoot\Completers\*.ps1 | ForEach-Object {
    . $_.FullName
}
