<#
.SYNOPSIS
    Gets folders in a Windows library
.DESCRIPTION
    Returns each folder in the specified library
#>
function Get-LibraryFolder {

    [CmdletBinding()]
    param(
        # Library name to get folders for
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    process {
        # Read library XML definition
        $XML = Read-LibraryDefinition $Name

        # Get library locations
        $Locations = $XML.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription

        # For each location in the library...
        foreach ($Location in $Locations) {

            # Get URL of the location
            $URL = $Location.simpleLocation.url
            
            # Resolve the path
            $ResolvedPath = Resolve-LibraryLocation -URL $URL
            
            # Determine type
            $Type = if ($URL -like 'knownfolder:*') {
                'KnownFolder'
            }
            else {
                'FileSystem'
            }

            # Construct object and output
            [PSCustomObject]@{
                PSTypeName            = 'FSUtils.WindowsLibraries.LibraryLocation'
                Library               = $Name
                Type                  = $Type
                URL                   = $URL
                ResolvedPath          = $ResolvedPath
                IsDefaultSaveLocation = [bool]$Location.isDefaultSaveLocation
            }
        }
    }

}
