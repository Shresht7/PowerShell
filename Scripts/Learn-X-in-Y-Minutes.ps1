<#
.SYNOPSIS
    Fuzzy search and display Learn X in Y Minutes documentation
.DESCRIPTION
    This script allows you to fuzzy search through a local sparse-checkout
    of the Learn X in Y Minutes documentation and display the content.

    The sparse-checkout is stored in the user's home directory under "References/learnxinyminutes-docs".
    If the repository is not already cloned, it will be cloned with sparse-checkout enabled to only checkout the files in the root of the repository;
    this includes all markdown files in the root directory.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1
    This will open a fuzzy selection interface in the console where you can select a markdown file from the Learn X in Y Minutes documentation.
    The content of the selected file will be displayed in `bat` with syntax highlighting.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1 -Output Content
    This will output the raw content of the selected markdown file in the console.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1 -Output Path
    This will output the location of the selected markdown files in the console. Read to be used in combination with other tools or scripts.
.NOTES
    Required Modules:
        Requires `git` for cloning the repository and updating it. (https://git-scm.com/)
        Requires `Select-Fuzzy` for fuzzy searching and previewing.
        Requires `bat` for syntax highlighted output and paging. (https://github.com/sharkdp/bat)
.LINK
    https://github.com/adambard/learnxinyminutes-docs
#>

[CmdletBinding()]
param (
    # The output format of the selected file.
    # Can be "Content" to display the content of the file,
    # "Pager" to display the content in `bat` with syntax highlighting,
    # or "Path" to display the path of the file.
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateSet("Content", "Pager", "Path")]
    [string] $Output = "Pager"
)

# Path to the References folder
$References = "$Home\References"

# If the References folder does not exist, create it
if (-not (Test-Path $References)) {
    Write-Verbose "Creating References folder at '$References'"
    New-Item -ItemType Directory -Path $References -Force
}

# Path to the git repository (sparse-checkout) folder of https://github.com/adambard/learnxinyminutes-docs
$ReferenceGitFolder = Join-Path $References "learnxinyminutes-docs"

# If the learnxinyminutes-docs git folder does not exist create it and do a sparse-checkout
if (-not (Test-Path $ReferenceGitFolder)) {
    Write-Verbose "Cloning learnxinyminutes-docs repository with sparse-checkout enabled to '$ReferenceGitFolder'"
    # Clone the repository with sparse-checkout enabled to only checkout the files in the root of the repository
    git clone --depth 1 --sparse https://github.com/adambard/learnxinyminutes-docs.git $ReferenceGitFolder
}

# TODO: Do a git fetch and pull to update the repository

# Fuzzy select a markdown file from the root of the learnxinyminutes-docs repository
$Selection = Get-ChildItem -Path $ReferenceGitFolder -File -Filter *.md |
Select-Fuzzy -Property BaseName -MultiSelect -Preview { bat $_.FullName --color=always --language $_.Extension.TrimStart('.') }

# If no file is selected, exit the script
if ($null -eq $Selection) {
    Write-Warning "No file selected"
    exit
}

switch ($Output) {
    "Content" {
        # Output the content of the selected file to the console
        Get-Content -Path $Selection.FullName
    }
    "Pager" {
        bat $Selection.FullName --language $Selection.Extension.TrimStart('.')
    }
    "Path" {
        # Output the path of the selected file to the console
        $Selection.FullName
    }
}
