
<#
.SYNOPSIS
    Finds which libraries the folder belongs to
.DESCRIPTION
    Finds which libraries the folder belongs to.
.EXAMPLE
    Find-LibraryPath "C:\Documents"
    Returns all the libraries containing the folder
.EXAMPLE
    Find-LibraryPath
    Returns all libraries containing the current folder
#>
function Find-LibraryPath {
 
    [CmdletBinding()]
    param(
        # Path to search for in libraries, defaults to current location
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("FullName", "ResolvedPath", "Path")]
        [string] $SearchPath = (Get-Location).Path
    )

    process {
        foreach ($Library in Get-Library) {
            $folders = Get-Library $Library.Name
            foreach ($folder in $folders) {
                $SearchPath = $SearchPath.TrimEnd('\')
                $folderPath = $folder.ResolvedPath.TrimEnd('\')
                if ($folderPath -like $SearchPath) {
                    [PSCustomObject]@{
                        Library               = $Library.Name
                        Type                  = $folder.Type
                        Path                  = $folder.ResolvedPath
                        URL                   = $folder.URL
                        IsDefaultSaveLocation = $folder.IsDefaultSaveLocation
                    }
                }
            }
        }       
    }

}
