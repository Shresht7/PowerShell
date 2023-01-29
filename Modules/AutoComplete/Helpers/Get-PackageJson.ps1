<#
TODO: Add documentation comments
#>
function Get-PackageJson(
    # The path to the package.json file
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = $PWD.Path
) {
    $PackageJson = Join-Path -Path $Path -ChildPath "package.json"
    return Get-Content $PackageJson -ErrorAction SilentlyContinue | ConvertFrom-Json
}
