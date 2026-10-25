# -------
# IMPORTS
# -------

if (-not ('FSUtils.WindowsLibraries.ShellLibraryInterop' -as [type])) {
    Add-Type -Path "$PSScriptRoot\Private\ShellLibrary.cs"
}

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
    @{ Name = 'Open-Library'; Parameter = 'Name' }
    @{ Name = 'Export-Library'; Parameter = 'Name' }
    @{ Name = 'Get-LibraryFolder'; Parameter = 'Name' }
    @{ Name = 'Add-LibraryFolder'; Parameter = 'Name' }
    @{ Name = 'Remove-LibraryFolder'; Parameter = 'Name' }
    @{ Name = 'Set-LibraryDefaultSaveFolder'; Parameter = 'Name' }
)

foreach ($cmd in $LibraryCommands) {
    Register-ArgumentCompleter -CommandName $cmd.Name -ParameterName $cmd.Parameter -ScriptBlock $LibraryCompleter
}

