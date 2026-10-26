<#
.SYNOPSIS
    Saves the XML to the specified path
.DESCRIPTION
    Writes a saved search XML definition to a file
#>
#>
function Write-SavedSearchDefinition {
    param(
        # XML document to write
        [Parameter(Mandatory)]
        [System.Xml.XmlDocument] $Document,

        # Path to save XML
        [Parameter(Mandatory)]
        [string] $Path
    )

    $Settings = [System.Xml.XmlWriterSettings]::new()
    $Settings.Encoding = [System.Text.UTF8Encoding]::new($false)
    $Settings.Indent = $true
    $Writer = [System.Xml.XmlWriter]::Create($Path, $Settings)
    try {
        $Document.Save($Writer)
    }
    finally {
        $Writer.Dispose()
    }
}
