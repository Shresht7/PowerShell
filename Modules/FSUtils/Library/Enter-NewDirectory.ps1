<#
.SYNOPSIS
    Creates a new directory and enters it
.DESCRIPTION
    Creates a new directory using `New-Item` and then `Set-Location`s to it
.EXAMPLE
    Enter-NewDirectory -Path "TestApplication"
    Creates a directory called "TestApplication" and `Set-Location`s to it
#>
function Enter-NewDirectory(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Item", "Directory", "Folder")]
    [string] $Path
) {
    # Create the directory if it does not exist
    if (-Not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force
    }
    # Set-Location to it
    Set-Location -Path $Path
}
