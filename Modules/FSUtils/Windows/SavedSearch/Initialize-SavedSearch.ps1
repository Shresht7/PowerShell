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
    'Set-SavedSearch',
    'Open-SavedSearch',
    'Remove-SavedSearch'
)

foreach ($cmd in $cmds) {
    Register-ArgumentCompleter -CommandName $cmd -ParameterName 'Name' -ScriptBlock $SavedSearchCompleter
}

$NewSavedSearchCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    Complete-SavedSearchArgument -ParameterName $ParameterName -WordToComplete $WordToComplete
}

foreach ($parameter in @('Kind', 'SortBy', 'SortDirection', 'Condition')) {
    Register-ArgumentCompleter -CommandName 'New-SavedSearch' -ParameterName $parameter -ScriptBlock $NewSavedSearchCompleter
}

foreach ($parameter in @('Kind', 'SortBy', 'SortDirection', 'Condition')) {
    Register-ArgumentCompleter -CommandName 'Set-SavedSearch' -ParameterName $parameter -ScriptBlock $NewSavedSearchCompleter
}
