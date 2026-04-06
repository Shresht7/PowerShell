<#
.SYNOPSIS
    Gets the file name of a file or directory from a given path.
.DESCRIPTION
    This function extracts the file name (including extension) from a provided file or directory path.
.EXAMPLE
    Get-FileName -Path "C:\Folder\File.txt"
    Returns: "File.txt"
.EXAMPLE
    Get-FileName -Path "C:\Folder\SubFolder"
    Returns: "SubFolder"
.EXAMPLE
    Get-ChildItem -Path "C:\Folder" | Get-FileName
    Gets the file names of all files and directories in "C:\Folder".
#>
function Get-FileName {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # The path to extract the file name from
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path $_ })]
        [Alias("Name", "FullName", "FilePath", "FileName", "File", "Dir", "Directory", "DirPath", "DirectoryPath", "Folder", "Location", "Input", "InputObject")]
        [string]$Path = ($PWD.Path)
    )

    process {
        # Use the System.IO.Path class to get the file name of the provided path
        [System.IO.Path]::GetFileName($Path)
    }
}

Set-Alias -Name filename -Value Get-FileName
