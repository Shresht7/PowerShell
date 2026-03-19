<#
.SYNOPSIS
    Remove one or more node_modules folders.
.DESCRIPTION
    Removes the `node_modules` folder from one or more target directories.
    If called without `-Path`, interactively selects folders under the current
    working directory that contain a `node_modules` folder. Supports pipeline
    input and `-WhatIf`/`-Confirm` via `SupportsShouldProcess`.
.PARAMETER Path
    One or more paths. Each value may be a folder that contains a `node_modules`
    directory or the `node_modules` directory itself.
.EXAMPLE
    Remove-NodeModules
    Interactively select folders under the current directory to remove
    their `node_modules` folders.
.EXAMPLE
    Remove-NodeModules -Path C:\Projects\MyProject
    Removes C:\Projects\MyProject\node_modules if it exists.
.EXAMPLE
    Get-ChildItem -Directory C:\Projects | Where-Object { Test-Path (Join-Path $_.FullName 'node_modules') } |
    ForEach-Object { $_.FullName } | Remove-NodeModules -WhatIf
    Demonstrates pipeline input and `-WhatIf` support.
.NOTES
    - Falls back to `Out-GridView` selection if `Select-Fuzzy` is not available.
    - Uses `Remove-Item -LiteralPath` and reports failures per path.
#>
function Remove-NodeModules {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias('Directory')]
        [string[]] $Path
    )

    begin {
        $selections = @()
        $hasSelectFuzzy = (Get-Command Select-Fuzzy -ErrorAction SilentlyContinue) -ne $null
    }

    process {
        if (-not $Path -or $Path.Count -eq 0) {
            # Discover candidate folders under current directory
            $candidates = Get-ChildItem -Directory -Path $PWD -ErrorAction SilentlyContinue |
            Where-Object { Test-Path -LiteralPath (Join-Path -Path $_.FullName -ChildPath 'node_modules') } |
            Select-Object -ExpandProperty FullName

            if (-not $candidates) {
                Write-Warning "No folders containing 'node_modules' found under $PWD"
                return
            }

            if ($hasSelectFuzzy) {
                $selected = $candidates | Select-Fuzzy -MultiSelect -Preview { Get-Size -Path "{}\\node_modules" }
            }
            else {
                $selected = $candidates | Out-GridView -Title "Select folders to remove node_modules from" -PassThru
            }

            if ($selected) {
                $selections += $selected
            }
        }
        else {
            $selections += $Path
        }
    }

    end {
        foreach ($p in $selections) {
            if (-not $p) { continue }

            $resolved = $null
            try { $resolved = Resolve-Path -LiteralPath $p -ErrorAction Stop } catch { }
            if (-not $resolved) {
                Write-Warning "Path not found or inaccessible: $p"
                continue
            }

            $target = $resolved.ProviderPath
            $leaf = Split-Path -Path $target -Leaf
            if ($leaf -ieq 'node_modules') {
                $nodePath = $target
            }
            else {
                $nodePath = Join-Path -Path $target -ChildPath 'node_modules'
            }

            if (-not (Test-Path -LiteralPath $nodePath)) {
                Write-Verbose "No node_modules found at: $nodePath"
                continue
            }

            if ($PSCmdlet.ShouldProcess($nodePath, 'Remove node_modules')) {
                try {
                    Remove-Item -LiteralPath $nodePath -Recurse -Force -ErrorAction Stop
                    Write-Verbose "Removed: $nodePath"
                }
                catch {
                    Write-Warning "Failed to remove '$nodePath': $($_.Exception.Message)"
                }
            }
        }
    }
}
