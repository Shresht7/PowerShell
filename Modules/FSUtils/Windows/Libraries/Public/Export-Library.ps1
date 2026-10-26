<#
.SYNOPSIS
    Exports a Windows library definition.
.DESCRIPTION
    Returns a library definition as an object or writes it as JSON.
.EXAMPLE
    Export-Library -Name 'Documents'
    Returns the library definition as an object.
.EXAMPLE
    Export-Library -Name 'Documents' -Path .\documents.json
    Writes the library definition to a JSON file.
.EXAMPLE
    Export-Library -Name 'Documents' -Path .\documents.json -Force
    Overwrites an existing JSON file.
#>
function Export-Library {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        # Name of the library to export
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Name,

        # Path to export the library to
        [string] $Path,

        # Overwrite an existing export file
        [switch] $Force
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
            PSTypeName    = 'PSFSUtils.WindowsLibraries.LibraryExport'
            Name          = $root.Name
            OwnerSID      = $root.ownerSID
            Version       = $root.Version
            IsPinned      = $root.isLibraryPinned -eq 'true'
            IconReference = $root.iconReference
            FolderType    = $root.templateInfo.folderType
            Locations     = $locations
        }

        if ($Path) {
            if ((Test-Path -LiteralPath $Path) -and -not $Force) {
                throw "Export path '$Path' already exists. Use -Force to overwrite it."
            }

            $json = $export | ConvertTo-Json -Depth 10
            if ($PSCmdlet.ShouldProcess($Path, 'Export library')) {
                $json | Set-Content -LiteralPath $Path -Encoding UTF8
                Get-Item -LiteralPath $Path
            }
        }
        else {
            $export
        }

    }

}
