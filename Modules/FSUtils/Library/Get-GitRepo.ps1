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
    begin {
        $Res = [System.Collections.ArrayList]::new()
    }

    process {
        Get-ChildItem -Path $Path -Recurse -Directory -Hidden
        | Where-Object { $_.Name -eq ".git" }
        | ForEach-Object {
            $Folder = $_.Parent
            $Branch = (git -C "$Folder" branch --show-current)
            $LatestTagId = (git -C "$Folder" rev-list --tags --max-count=1)
            if ($LatestTagId) {
                $LatestTag = (git -C "$Folder" describe --tags $LatestTagId)
            }
            $Status = (git -C "$Folder" status --short)
            $Status = if ($Status -like " M *") { "modified" } else { "clean" }
            $null = $Res.Add([PSCustomObject]@{
                    Name      = $Folder.BaseName
                    Path      = $Folder
                    Branch    = $Branch
                    LatestTag = $LatestTag
                    Status    = $Status
                })
        }
    }

    end {
        $Res | Format-Table
    }
}
