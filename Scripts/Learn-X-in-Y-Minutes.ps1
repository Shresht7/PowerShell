<#
.SYNOPSIS
    Fuzzy search and display Learn X in Y Minutes documentation
.DESCRIPTION
    This script allows you to fuzzy search through a local sparse-checkout
    of the Learn X in Y Minutes documentation and display the content.

    The sparse-checkout is stored in the user's home directory under "~/References/learnxinyminutes-docs".
    If the repository is not already cloned, it will be cloned with sparse-checkout enabled to only checkout the files in the root of the repository;
    this includes all markdown files in the root directory.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1
    This will open a fuzzy selection interface where you can select a markdown file from the Learn X in Y Minutes documentation.
    The content of the selected files will be displayed in `bat` with syntax highlighting.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1 -Output Content
    This will output the raw content of the selected markdown files.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1 -Output Path
    This will output the location of the selected markdown files. Read to be used in combination with other tools or scripts.
.EXAMPLE
    .\learn-x-in-y-minutes.ps1 -Output Web
    This will open the selected markdown file in the web browser.
.NOTES
    Required Modules:
        Requires `git` for cloning the repository and updating it. (https://git-scm.com/)
        Requires `Select-Fuzzy` for fuzzy searching and previewing.
        Requires `bat` for syntax highlighted output and paging. (https://github.com/sharkdp/bat)
.LINK
    https://github.com/adambard/learnxinyminutes-docs
#>

[CmdletBinding(DefaultParameterSetName = "Show")]
param (
    # The output format of the selected file.
    # Can be "Content" to display the content of the file,
    # "Pager" to display the content in `bat` with syntax highlighting,
    # or "Path" to display the path of the file.
    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = "Show")]
    [ValidateSet("Content", "Pager", "Path", "Web")]
    [string] $Output = "Pager",

    # If specified, lists all the markdown files in the learnxinyminutes-docs repository 
    [Parameter(Mandatory = $false, ParameterSetName = "List")]
    [switch] $List
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

#  Do a git fetch and pull to update the repository
if (-not ([string]::IsNullOrEmpty( $(git -C $ReferenceGitFolder fetch --porcelain) ))) {
    Write-Verbose "Updating learnxinyminutes-docs repository at '$ReferenceGitFolder'"
    git -C $ReferenceGitFolder pull --ff-only
}

# Get the list of all markdown files in the root of the learnxinyminutes-docs repository
$MarkdownFiles = Get-ChildItem -Path $ReferenceGitFolder -File -Filter *.md

# If the -List switch is specified, output the list of markdown files and exit
if ($List) {
    $MarkdownFiles
    exit
}

# Use Select-Fuzzy to select one or more markdown files from the list of markdown files with a preview of the content of the file in `bat` with syntax highlighting
$Selection = $MarkdownFiles |
Select-Fuzzy -Property BaseName -MultiSelect -Preview { bat $_.FullName --color=always --language $_.Extension.TrimStart('.') }

# If no file is selected, exit the script
if ($null -eq $Selection) {
    Write-Warning "No file selected"
    exit
}

switch ($Output) {
    "Content" {
        # Output the raw contents of the selected files
        Get-Content -Path $Selection.FullName -Raw
    }
    "Pager" {
        # Display the content of the selected file in `bat` with syntax highlighting
        bat $Selection.FullName --language $Selection.Extension.TrimStart('.')
    }
    "Path" {
        # Output the location of the selected files
        $Selection
    }
    "Web" {
        # Open the selected markdown file in the web browser
        Start-Process https://learnxinyminutes.com/$($Selection.BaseName)
    }
}
