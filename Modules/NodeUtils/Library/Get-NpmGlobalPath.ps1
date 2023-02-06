<#
.SYNOPSIS
    Get the path to the global npm folder
.DESCRIPTION
    Get the path to the global npm folder
.EXAMPLE
    Get-NpmGlobalPath
    Get the path to the global npm folder
#>
function Get-NpmGlobalPath {
    Find-Path -Command npm | Select-Object -First 1 | Split-Path -Parent
}
