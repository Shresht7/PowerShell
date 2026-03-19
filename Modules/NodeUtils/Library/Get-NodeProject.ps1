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
        if ($Recurse) {
            # Recursively find directories, excluding node_modules to keep it fast
            Get-ChildItem -Path $Path -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '[\\/]node_modules([\\/]|$)' } |
            Where-Object { Test-Path -LiteralPath (Join-Path -Path $_.FullName -ChildPath 'package.json') }
        }
        else {
            # Just check the current path and its immediate children
            $items = Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue
            # Also check the path itself if it's a project
            $targets = @(Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue) + $items
            # Filter to those that contain a package.json file
            $targets | Where-Object { Test-Path -LiteralPath (Join-Path -Path $_.FullName -ChildPath 'package.json') }
        }
    }
}
