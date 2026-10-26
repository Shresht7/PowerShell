<#
.SYNOPSIS
    Renames an existing Windows saved search.
.DESCRIPTION
    Renames the .search-ms file without changing its contents. Names are
    base names only; do not include the .search-ms extension.
.EXAMPLE
    Rename-SavedSearch -Name 'Large PDFs' -NewName 'Large PDF Documents'
    Renames a saved search while preserving its definition.
.EXAMPLE
    Get-SavedSearch -Name 'Large PDFs' | Rename-SavedSearch -NewName 'Large PDF Documents'
    Renames a saved search received through the pipeline.
.EXAMPLE
    Rename-SavedSearch -Name 'Large PDFs' -NewName 'Large PDF Documents' -WhatIf
    Shows what would happen without renaming the file.
#>
function Rename-SavedSearch {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        # Name of the saved search to rename
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('Search', 'SearchName')]
        [string] $Name,

        # New name for the search
        [Parameter(Mandatory, Position = 1)]
        [string] $NewName
    )

    process {
        Test-SavedSearchName -Name $Name | Out-Null
        Test-SavedSearchName -Name $NewName | Out-Null
        $SourcePath = Resolve-SavedSearchPath $Name
        $DestinationPath = Join-Path (Get-SavedSearchPath) "$NewName.search-ms"

        if (Test-Path -LiteralPath $DestinationPath) {
            throw "Saved search '$NewName' already exists."
        }

        if ($PSCmdlet.ShouldProcess($SourcePath, "Rename saved search to '$NewName'")) {
            Rename-Item -LiteralPath $SourcePath -NewName "$NewName.search-ms"
            Get-Item -LiteralPath $DestinationPath
        }
    }
}
