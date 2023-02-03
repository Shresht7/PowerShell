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
function Get-PackageJson(
    # The path to the package.json file
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = (Join-Path -Path $PWD.Path -ChildPath "package.json")
) {
    # Get the item at the given path
    $Item = Get-Item -Path $Path

    # If the path is a directory, then append the package.json file name
    if ($Item.PSIsContainer) {
        $Path = Join-Path -Path $Path -ChildPath "package.json"
    }

    # Get the contents of the package.json file
    return Get-Content $Path -ErrorAction SilentlyContinue | ConvertFrom-Json
}
