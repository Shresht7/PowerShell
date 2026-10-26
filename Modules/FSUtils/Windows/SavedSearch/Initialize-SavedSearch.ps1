# -------
# IMPORTS
# -------

Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# ------------------
# ARGUMENT COMPLETER
# ------------------

$SavedSearchCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    Complete-SavedSearchName -WordToComplete $WordToComplete
}

$cmds = @(
    'Get-SavedSearch',
    'New-SavedSearch',
    'Open-SavedSearch',
    'Remove-SavedSearch'
)

foreach ($cmd in $cmds) {
    Register-ArgumentCompleter -CommandName $cmd -ParameterName 'Name' -ScriptBlock $SavedSearchCompleter
}
