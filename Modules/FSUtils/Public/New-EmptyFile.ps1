<#
.SYNOPSIS
    Creates a new empty file at the specified path.
.DESCRIPTION
    This function creates a new empty file at the given path. If the file already exists,
    it will not be overwritten unless the -Force parameter is specified.
.EXAMPLE
    New-EmptyFile -Path "C:\Folder\NewFile.txt"
    Creates a new empty file named "NewFile.txt" in the "C:\Folder" directory.
.EXAMPLE
    New-EmptyFile -Path "C:\Folder\ExistingFile.txt" -Force
    If "ExistingFile.txt" already exists in "C:\Folder", it will be overwritten with a new empty file.
.EXAMPLE
    "C:\Folder\NewFile.txt" | New-EmptyFile
    Creates a new empty file at the specified path using pipeline input.
.NOTES
    Mimics the behavior of the Unix 'touch' command for creating empty files.
#>
function New-EmptyFile {
    [CmdletBinding()]
    param (
        # The path of the new empty file to create
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Name", "NewName", "FullName", "File", "FilePath", "FileName")]
        [string] $Path,

        # If specified, forces the creation of the file even if it already exists
        [switch] $Force
    )

    process {
        # Check if the file already exists
        if (Test-Path -Path $Path) {
            if ($Force) {
                # If the file exists and Force is specified, remove the existing file
                Remove-Item -Path $Path -Force -ErrorAction Stop
            }
            else {
                Write-Warning "The file '$Path' already exists. Use -Force to overwrite it."
                return
            }
        }

        # Create a new empty file at the specified path
        New-Item -Path $Path -ItemType File -Force:$Force -ErrorAction Stop | Out-Null
    }
    
}

Set-Alias -Name touch -Value New-EmptyFile
