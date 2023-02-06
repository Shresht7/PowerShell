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
    return (npm config get prefix)
}
