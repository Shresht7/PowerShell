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

    $Directory = Split-Path -Parent $Path
    $TemporaryPath = Join-Path $Directory ".tmp-$([guid]::NewGuid().ToString('N')).search-ms"

    try {
        $Settings = [System.Xml.XmlWriterSettings]::new()
        $Settings.Encoding = [System.Text.UTF8Encoding]::new($false)
        $Settings.Indent = $true

        $Writer = [System.Xml.XmlWriter]::Create($TemporaryPath, $Settings)
        try {
            $Document.Save($Writer)
        }
        finally {
            $Writer.Dispose()
        }

        if (Test-Path -LiteralPath $Path) {
            [System.IO.File]::Move($TemporaryPath, $Path, $true)
        }
        else {
            [System.IO.File]::Move($TemporaryPath, $Path)
        }
    }
    finally {
        if (Test-Path -LiteralPath $TemporaryPath) {
            Remove-Item -LiteralPath $TemporaryPath -Force -ErrorAction SilentlyContinue
        }
    }
}
