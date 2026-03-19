<#
.SYNOPSIS
    Get the contents of a package.json file
.DESCRIPTION
    Get the contents of a package.json file
.EXAMPLE
    Get-PackageJson
    Get the contents of the package.json file in the current directory
.EXAMPLE
    Get-PackageJson -Path "C:\Projects\MyProject"
    Get the contents of the package.json file in the given directory
.EXAMPLE
    Get-PackageJson -Path "C:\Projects\MyProject\package.json"
    Get the contents of the package.json file in the given path
#>
function Get-PackageJson {

    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        # The path to the package.json file
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript({ Test-Path -Path $_ })]
        [Alias("PackagePath", "PackageJsonPath", "FilePath")]
        [string]$Path = (Get-Location).Path
    )
     
    # Check if the path is valid and points to a package.json file
    if (-Not (Test-Path -Path $Path)) {
        Write-Warning "The path '$Path' does not exist."
        return
    }

    # If the path is a directory, then append the package.json file name
    if (Test-Path -Path $Path -PathType Container) {
        $Path = Join-Path -Path $Path -ChildPath "package.json"
    }

    # Resolve the path to the package.json file
    $Path = Resolve-Path -Path $Path -ErrorAction SilentlyContinue

    # Check if the package.json file exists
    if (-Not (Test-Path -Path $Path)) {
        Write-Warning "The package.json file was not found at the path '$Path'."
        return
    }
    
    # Get the contents of the package.json file
    return Get-Content $Path -ErrorAction SilentlyContinue | ConvertFrom-Json
}
