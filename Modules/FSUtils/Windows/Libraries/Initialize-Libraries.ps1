# -------
# IMPORTS
# -------

Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}


# ----------------------------
# REGISTER ARGUMENT COMPLETERS
# ----------------------------

$LibraryCompleter = {
    param(
        $CommandName,
        $ParameterName,
        $WordToComplete,
        $CommandAst,
        $FakeBoundParameters
    )

    Complete-LibraryName -WordToComplete $WordToComplete
}

$LibraryCommands = @(
    @{ Name = 'Get-Library'; Parameter = 'Name' }
    @{ Name = 'Open-Library'; Parameter = 'Library' }
    @{ Name = 'Export-Library'; Parameter = 'Name' }
)

foreach ($cmd in $LibraryCommands) {
    Register-ArgumentCompleter -CommandName $cmd.Name -ParameterName $cmd.Parameter -ScriptBlock $LibraryCompleter
}

