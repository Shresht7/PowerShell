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

Register-ArgumentCompleter -CommandName Get-Library -ParameterName Name -ScriptBlock $LibraryCompleter
Register-ArgumentCompleter -CommandName Open-Library -ParameterName Library -ScriptBlock $LibraryCompleter
Register-ArgumentCompleter -CommandName Export-Library -ParameterName Name -ScriptBlock $LibraryCompleter
