function Export-Library {

    [CmdletBinding()]
    param(
        # Name of the library to export
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [string] $Path
    )

    process {

        $File = Get-LibraryFile | Where-Object BaseName -eq $Name

        if (-not $File) {
            throw "Library '$Name' not found!"
        }

        [xml]$XML = Get-Content $File.FullName -Raw
        $root = $XML.libraryDescription

        $locations = @(
            $root.searchConnectorDescriptionList.searchConnectorDescription
        ) | ForEach-Object {
            [PSCustomObject]@{
                URL                           = $_.simpleLocation.url
                IsDefaultSaveLocation         = $_.isDefaultSaveLocation
                IsDefaultNonOwnerSaveLocation = $_.isDefaultNonOwnerSaveLocation
                IsSupported                   = $_.isSupported
                Publisher                     = $_.publisher
                Description                   = $_.description
            }
        }

        $export = [PSCustomObject]@{
            Name          = $root.Name
            OwnerSID      = $root.ownerSID
            Version       = $root.Version
            IsPinned      = $root.isLibraryPinned
            IconReference = $root.iconReference
            FolderType    = $root.templateInfo.folderType
            Locations     = $locations
        }

        if ($Path) {
            $json = $export | ConvertTo-Json -Depth 2
            $json | Set-Content -Path $Path -Encoding UTF8
            Get-Item -Path $Path
        }
        else {
            $export
        }

    }

}
