# Retrieves the list of npm scripts from the package json
function Get-NpmScript(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $Package = Get-PackageJson $Path

    if (-Not $Package) { return }

    $scripts = $Package.scripts |
    Get-Member -MemberType NoteProperty |
    Select-Object -Property Name, @{Name = "Script"; Expression = { $Package.scripts.($_.Name) } }

    return $scripts
}
