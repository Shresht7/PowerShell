<#
.SYNOPSIS
    Returns a list of git repositories
.DESCRIPTION
    Returns a list of git repositories in the given path looking recursively.
.EXAMPLE
    Get-GitRepo
    Returns a list of git repositories in the current directory
.EXAMPLE
    Get-Repo -Path ".\Some\Other\Path"
    Returns a list of git repositories in some other path
#>
function Get-GitRepo(
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path = "."
) {
    Get-ChildItem -Path $Path -Recurse -Directory -Hidden
    | Where-Object { $_.Name -eq ".git" }
    | ForEach-Object { $_.Parent }
}
