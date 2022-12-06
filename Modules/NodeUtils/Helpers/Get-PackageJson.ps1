# Retrieves package information from the package json
function Get-PackageJson(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $PackageJson = Join-Path $Path "package.json"

    return Get-Content $PackageJson -ErrorAction SilentlyContinue | ConvertFrom-Json
}
