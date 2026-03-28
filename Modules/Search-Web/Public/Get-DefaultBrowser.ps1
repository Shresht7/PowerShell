<#
.SYNOPSIS
    Retrieves the ProgId of the default web browser.
.DESCRIPTION
    This function checks the Windows registry to find the ProgId associated with the default web browser for
.EXAMPLE
    Get-DefaultBrowser
    Retrieves the ProgId of the default web browser, such as "MSEdgeHTM" for Microsoft Edge or "ChromeHTML" for Google Chrome.
#>
function Get-DefaultBrowser {
    $defaultBrowserKey = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice"

    $progId = $null
    if (Test-Path $defaultBrowserKey) {
        $progId = (Get-ItemProperty -Path $defaultBrowserKey).ProgId
    }
    else {
        Write-Warning "Default browser information not found."
        return $null
    }

    switch ($progId) {
        "MSEdgeHTM" { return "Edge" }
        "ChromeHTML" { return "Chrome" }
        default { return $progId }
    }
}
