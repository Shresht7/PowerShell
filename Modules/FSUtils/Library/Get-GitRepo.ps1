<#
.SYNOPSIS
    Get information about Git repositories in a specified directory
.DESCRIPTION
    This cmdlet searches the specified directory and its subdirectories for Git repositories, and then
    returns information about each repository it finds. This includes the repository's name, path, current branch,
    latest tag, and status (modified or clean)
.OUTPUTS
    System.Object
        An object that contains information about each Git repository that was found.
.EXAMPLE
    Get-GitRepo
    Returns information about all Git repositories in the current directory and its subdirectories.
.EXAMPLE
    Get-GitRepo -Path "C:\Repos"
    Returns information about all Git repositories in the specified directory and its subdirectories.
.NOTES
    This function requires the `git` command-line utility to be installed and available on the system.
#>
function Get-GitRepo(
    # The path to the directory to search for Git repositories. Defaults to the current directory.
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path = "."
) {
    begin {
        $Results = [System.Collections.ArrayList]::new()
    }

    process {
        # Find `.git` directories
        Get-ChildItem -Path $Path -Recurse -Directory -Hidden
        | Where-Object { $_.Name -eq ".git" }
        | ForEach-Object {
            # Select the parent folder
            $Folder = $_.Parent

            # Get the current branch
            $Branch = (git -C "$Folder" branch --show-current)
            # Get the latest tag
            $LatestTagId = (git -C "$Folder" rev-list --tags --max-count=1)
            if ($LatestTagId) {
                $LatestTag = (git -C "$Folder" describe --tags $LatestTagId)
            }
            # Get the current status of the repository
            $Status = (git -C "$Folder" status --short)
            $Status = if ($Status -like " M *") { "modified" } else { "clean" }

            # Store the results
            $null = $Results.Add([PSCustomObject]@{
                    Name      = $Folder.BaseName
                    Path      = $Folder
                    Branch    = $Branch
                    LatestTag = $LatestTag
                    Status    = $Status
                })
        }
    }

    end {
        $Results | Format-Table
    }
}
