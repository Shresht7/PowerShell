<#
.SYNOPSIS
    Get the list of npm scripts from a package.json file
.DESCRIPTION
    Get the list of npm scripts from a package.json file
.EXAMPLE
    Get-NpmScript
    Get the list of npm scripts from the package.json file in the current directory
.EXAMPLE
    Get-NpmScript -Path "C:\Projects\MyProject"
    Get the list of npm scripts from the package.json file in the given directory
.EXAMPLE
    Get-NpmScript -Path "C:\Projects\MyProject\package.json"
    Get the list of npm scripts from the package.json file in the given path
#>
function Get-NpmScript(
    # Path to the package.json file
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = $PWD.Path
) {

    # Get the package.json contents
    $Package = Get-PackageJson -Path $Path

    # Exit if the package is not found
    if (-Not $Package) { return }

    # Get the npm scripts from the package.json file
    $Scripts = $Package.scripts
    | Get-Member -MemberType NoteProperty
    | Select-Object -Property Name, @{ Name = "Script"; Expression = { $Package.scripts.($_.Name) } }

    # Return the list of scripts
    return $Scripts
    
}
