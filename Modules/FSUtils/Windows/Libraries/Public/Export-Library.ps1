function Export-Library {

    [CmdletBinding()]
    param(
        # Name of the library to export
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Name,

        # Path to export the library to
        [string] $Path
    )

    process {

        $File = Get-LibraryFile -Name $Name

        if (-not $File) {
            throw "Library '$Name' not found!"
        }

        [xml]$XML = Read-LibraryDefinition $Name
        $root = $XML.libraryDescription

        $locations = @(
            $root.searchConnectorDescriptionList.searchConnectorDescription
        ) | ForEach-Object {
            [PSCustomObject]@{
                URL                           = $_.simpleLocation.url
                IsDefaultSaveLocation         = $_.isDefaultSaveLocation -eq 'true'
                IsDefaultNonOwnerSaveLocation = $_.isDefaultNonOwnerSaveLocation -eq 'true'
                IsSupported                   = $_.isSupported -eq 'true'
                Publisher                     = $_.publisher
                Description                   = $_.description
            }
        }

        $export = [PSCustomObject]@{
            PSTypeName    = 'FSUtils.WindowsLibraries.LibraryExport'
            Name          = $root.Name
            OwnerSID      = $root.ownerSID
            Version       = $root.Version
            IsPinned      = $root.isLibraryPinned -eq 'true'
            IconReference = $root.iconReference
            FolderType    = $root.templateInfo.folderType
            Locations     = $locations
        }

        if ($Path) {
            $json = $export | ConvertTo-Json -Depth 10
            $json | Set-Content -Path $Path -Encoding UTF8
            Get-Item -Path $Path
        }
        else {
            $export
        }

    }

}
