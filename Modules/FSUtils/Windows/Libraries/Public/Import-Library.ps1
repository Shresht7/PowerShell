<#
.SYNOPSIS
    Creates a library from a JSON definition
.DESCRIPTION
    Reads a JSON file (as written by Export-Library, or by hand) and creates the
    library with its folders and default save location.
    knownfolder: entries are added as known folders, so they keep following the
    folder if Windows relocates it. Other paths may use environment variables.
    Folders that don't exist on this machine are skipped with a warning.
    With -Merge, an existing library gets the missing folders; nothing is removed.
.EXAMPLE
    Import-Library -Path .\work.json
.EXAMPLE
    Import-Library -Path .\work.json -Name Work2 -Merge
#>
function Import-Library {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        # JSON file with the library definition
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string] $Path,

        # Library name; defaults to the Name in the JSON
        [string] $Name,

        # Add to the library if it already exists, instead of failing
        [switch] $Merge
    )

    process {
        $json = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
        $libName = if ($Name) { $Name } else { $json.Name }

        if (-not $libName) {
            Write-Error "No library name in '$Path'. Pass -Name."
            return
        }

        $exists = [bool](Get-LibraryFile -Name $libName)
        if ($exists -and -not $Merge) {
            Write-Error "Library '$libName' already exists. Use -Merge to add to it."
            return
        }

        $action = if ($exists) { "Merge '$Path' into library" } else { "Create library from '$Path'" }
        if (-not $PSCmdlet.ShouldProcess($libName, $action)) { return }

        Initialize-ShellLibraryInterop
        $interop = [PSFSUtils.WindowsLibraries.ShellLibraryInterop]

        if (-not $exists) { New-Library -Name $libName }
        $libFile = Resolve-LibraryPath $libName

        $present = @((Get-LibraryFolder -Name $libName).ResolvedPath)
        $default = $null

        foreach ($loc in @($json.Locations)) {
            $url = $loc.URL
            if (-not $url) { continue }

            try {
                if ($url -match '^knownfolder:\{(.+)\}$') {
                    $id = [guid] $Matches[1]
                    $resolved = Resolve-KnownFolder -Id $id

                    if ($present -notcontains $resolved) {
                        $interop::AddKnownFolder($libFile, $id)
                    }
                }
                else {
                    $expanded = [Environment]::ExpandEnvironmentVariables($url)
                    $resolved = (Resolve-Path -LiteralPath $expanded -ErrorAction Stop).ProviderPath

                    if ($present -notcontains $resolved) {
                        $interop::AddFolder($libFile, $resolved)
                    }
                }

                if ([string]$loc.IsDefaultSaveLocation -eq 'true') { $default = $resolved }
            }
            catch {
                Write-Warning "Skipped '$url': $($_.Exception.Message)"
            }
        }

        if ($default) {
            $interop::SetDefaultSaveFolder($libFile, $default)
        }

        Get-Library -Name $libName
    }
}
