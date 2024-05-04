<#
.SYNOPSIS
    Get the content of a file in a GitHub Gist
.DESCRIPTION
    Get the content of a file in a GitHub Gist. The user will be prompted to select a Gist and then a file from that Gist.
    The content of the selected file will be returned.
.EXAMPLE
    Get-GitHubGist
    Prompts the user to select a GitHub Gist and then a file from that Gist. The content of the selected file is returned.
.EXAMPLE
    Get-GitHubGist -ID "1234567890abcdef"
    Gets the content of the file in the GitHub Gist with the ID "1234567890abcdef".
.NOTES
    Requires the GitHub CLI (gh) to be installed.
    Requires fzf to be installed.
#>
[CmdletBinding()]
param(
    # The ID of the GitHub Gist to retrieve (if not specified, the user will be prompted to select one)
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('GistID')]
    [string] $ID = (gh gist list | fzf -d"\t" --preview "gh gist view {1}" | Split-String -Delimiter "\t" -Index 0)
)

# Get the files in the Gist
$Files = gh gist view $ID --files

# Prompt the user to select a file from the Gist using fzf
$File = $Files | fzf --preview "gh gist view $ID --filename {1}"

# Get the content of the selected file
$Content = gh gist view $ID --filename $File

# Return the content of the file
return $Content
