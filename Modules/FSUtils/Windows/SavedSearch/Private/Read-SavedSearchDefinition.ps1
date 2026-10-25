<#
.SYNOPSIS
    Reads a saved search definition
.DESCRIPTION
    Returns the XML of the saved search file.
#>
function Read-SavedSearchDefinition {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )
    $xml = [xml]::new()
    $xml.Load($Path)
    $xml
}
