<#
.SYNOPSIS
    Gets the base name of a file or directory from a given path.
.DESCRIPTION
    This function extracts the base name (file name without extension) from a provided file or directory path.
.EXAMPLE
    Get-BaseName -Path "C:\Folder\File.txt"
    Returns: "File"
.EXAMPLE
    Get-BaseName -Path "C:\Folder\SubFolder"
    Returns: "SubFolder"
.EXAMPLE
    Get-ChildItem -Path "C:\Folder" | Get-BaseName
    Gets the base names of all files and directories in "C:\Folder".
#>
function Get-BaseName {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # The path to extract the base name from
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path $_ })]
        [Alias("Name", "FullName", "FilePath", "FileName", "File", "Dir", "Directory", "DirPath", "DirectoryPath", "Folder", "Location", "Input", "InputObject")]
        [string]$Path
    )

    process {
        # Use the System.IO.Path class to get the base name of the provided path
        [System.IO.Path]::GetFileNameWithoutExtension($Path)
    }
}

Set-Alias -Name basename -Value Get-BaseName
