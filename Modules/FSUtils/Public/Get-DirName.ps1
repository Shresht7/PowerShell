<#
.SYNOPSIS
    Gets the directory name of a file or directory from a given path.
.DESCRIPTION
    This function extracts the directory name from a provided file or directory path.
.EXAMPLE
    Get-DirName -Path "C:\Folder\File.txt"
    Returns: "C:\Folder"
.EXAMPLE
    Get-DirName -Path "C:\Folder\SubFolder"
    Returns: "C:\Folder"
.EXAMPLE
    Get-ChildItem -Path "C:\Folder" | Get-DirName
    Gets the directory names of all files and directories in "C:\Folder".
#>
function Get-DirName {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # The path to extract the directory name from
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path $_ })]
        [Alias("Name", "FullName", "FilePath", "FileName", "File", "Dir", "Directory", "DirPath", "DirectoryPath", "Folder", "Location", "Input", "InputObject")]
        [string]$Path
    )

    process {
        # Use the System.IO.Path class to get the directory name of the provided path
        $ResolvedPath = Resolve-Path -Path $Path -ErrorAction Stop
        [System.IO.Path]::GetDirectoryName($ResolvedPath)
    }
}

Set-Alias -Name dirname -Value Get-DirName
