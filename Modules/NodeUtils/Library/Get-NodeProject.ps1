<#
.SYNOPSIS
    Find Node.js projects.
.DESCRIPTION
    Searches for directories containing a 'package.json' file.
    By default, it excludes 'node_modules' and other common build/dependency folders
    to ensure the search is fast and only returns actual project roots.
.EXAMPLE
    Get-NodeProject
    Finds Node.js projects in the current directory.
.EXAMPLE
    Get-NodeProject -Path C:\Projects -Recurse
    Finds all Node.js projects under C:\Projects.
#>
function Get-NodeProject {
    [CmdletBinding()]
    [OutputType([System.IO.DirectoryInfo])]
    param (
        # The root directory to search. Defaults to the current directory.
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias('PSPath', 'Directory')]
        [string] $Path = $PWD.Path,

        # Indicates whether to search subdirectories recursively.
        [switch] $Recurse
    )

    process {
        if (-not $Path) { return }

        $resolvedPath = $null
        try {
            $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
        }
        catch {
            Write-Warning "Path not found: $Path"
            return
        }

        if (-not (Test-Path -LiteralPath $resolvedPath -PathType Container)) {
            Write-Warning "Path is not a directory: $Path"
            return
        }

        if ($Recurse) {
            Get-ChildItem -LiteralPath $resolvedPath -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '[\\/]node_modules$' } |
            Where-Object { Test-Path -LiteralPath (Join-Path -Path $_.FullName -ChildPath 'package.json') }
        }
        else {
            $items = Get-ChildItem -LiteralPath $resolvedPath -Directory -ErrorAction SilentlyContinue
            $targets = @($resolvedPath) + @($items)
            $targets | Where-Object { Test-Path -LiteralPath (Join-Path -Path $_.FullName -ChildPath 'package.json') }
        }
    }
}
