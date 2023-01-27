$SearchEngines = Get-Content -Path "$PSScriptRoot\searchEngines.json" | ConvertFrom-Json

<#
.SYNOPSIS
    Search the web
.DESCRIPTION
    Launches the default web-browser to do a web-search using a search-engine
.EXAMPLE
    Search-Web 'PowerShell Documentation'
    Searches the web for 'PowerShell Documentation' using the default search engine
.EXAMPLE
    Search-Web 'Microsoft PowerToys' bing
    Searches the web for 'Microsoft PowerToys' using the 'bing' search engine
.EXAMPLE
    Search-Web -engine github -query 'Terminal'
    Searches GitHub for 'Terminal'
#>
function Search-Web(
    # The search query to perform
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Query,

    # The search engine to use to perform the search
    [string] $Engine = "google"
) {
    # Encode the query string
    $EncodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
 
    # Build the search query URL
    $Search = $SearchEngines | Where-Object { $_.shortcut -eq $Engine } | Select-Object -First 1
    $Search.url.Replace("%s", $EncodedQuery)
 
    # Launch the URL using the Start-Process cmdlet (opens the URL with the default browser)
    Start-Process $Search
}
