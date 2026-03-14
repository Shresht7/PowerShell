<#
.SYNOPSIS
    TODO: Add a synopsis for this script
.DESCRIPTION
    TODO: Add a description for this script
.EXAMPLE
    TODO: Show example usage
.NOTES
    TODO: Add any additional notes or information about this script
    Requires `Select-Fuzzy` and `bat` to be installed and available in the system PATH for fuzzy selection and preview functionality.
.LINK
    https://github.com/adambard/learnxinyminutes-docs
#>

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
    git clone --depth 1 --sparse https://github.com/adambard/learnxinyminutes-docs.git
}

# Fuzzy select a markdown file from the root of the learnxinyminutes-docs repository
Get-ChildItem -Path $ReferenceGitFolder -File -Filter *.md |
Select-Fuzzy -Property BaseName -MultiSelect -Preview { bat $_.FullName --color=always --language $_.Extension.TrimStart('.') }
