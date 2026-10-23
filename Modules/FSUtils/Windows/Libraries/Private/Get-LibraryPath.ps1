<#
.SYNOPSIS
    Returns the path to the Windows Libraries folder
.DESCRIPTION
    Returns the full path to the Libraries folder: $ENV:APPDATA\Microsoft\Windows\Libraries
    Throws an error if the folder doesn't exist.
.EXAMPLE
    Get-LibraryPath
    Returns the path to the Libraries folder
#>
function Get-LibraryPath {
    $path = Join-Path $Env:APPDATA 'Microsoft\Windows\Libraries'

    if (-not (Test-Path -Path $path)) {
        throw "Libraries folder not found! '$path'"
    }

    return $path
}
