<#
.SYNOPSIS
    Gets all libraries or a specific one by name
.DESCRIPTION
    By default, lists all Windows libraries. If a $Name is specified, show info for that specific library
#>
function Get-Library {

    # The name of the library to get. Can be omitted to list all libraries
    param(
        [string] $Name
    )

    # If no name is given, list all libraries
    if (-not $Name) {

        foreach ($File in Get-LibraryFile) {
            $XML = Read-LibraryDefinition $File.BaseName
            $Count = @(
                $XML.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription
            ).Count
            [PSCustomObject]@{
                Name    = $File.BaseName
                Pinned  = [bool]::Parse(
                    $XML.libraryDescription.isLibraryPinned
                )
                Folders = $Count
                # Icon        = $XML.libraryDescription.iconReference
            }
        }

        return
    }

    # Read the *.library-ms file (XML format)
    $XML = Read-LibraryDefinition $Name

    # Get all locations from the XML
    $Locations = $XML.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription

    foreach ($Location in $Locations) {
        # Get the URL of the location
        $URL = $Location.simpleLocation.url

        # Determine type of location
        $type = if ($URL -like 'knownfolder:*') {
            'KnownFolder'
        }
        else {
            'FileSystem'
        }

        # Construct and output object 
        [PSCustomObject]@{
            Library               = $Name
            Type                  = $type
            URL                   = $URL
            IsDefaultSaveLocation = $Location.isDefaultSaveLocation
        }
    }


}
