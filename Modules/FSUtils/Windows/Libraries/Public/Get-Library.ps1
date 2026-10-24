<#
.SYNOPSIS
    Gets a Windows library by name
.DESCRIPTION
    Gets a Windows library by name.
    Returns library details like path and pinned status.
#>
function Get-Library {

    [CmdletBinding()]
    param(
        # Name of the library to get
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    # Get all library files
    $Files = Get-LibraryFile

    # Filter by name if given
    if ($Name) {
        $Files = $Files | Where-Object BaseName -eq $Name
    }

    # Read each library file and get details
    foreach ($File in $Files) {

        # Read library XML definition
        $XML = Read-LibraryDefinition $File.BaseName

        # Count folders in library
        $FolderCount = @(
            $XML.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription
        ).Count

        # Construct object and output
        [PSCustomObject]@{
            PSTypeName  = 'FSUtils.WindowsLibraries.Library'
            Name        = $File.BaseName
            Path        = $File.FullName
            Pinned      = [bool]::Parse(
                $XML.libraryDescription.isLibraryPinned
            )
            FolderCount = $FolderCount
        }
    }

}
