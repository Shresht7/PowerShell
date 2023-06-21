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
 
    # Look for the search engine
    $Search = $Script:SearchEngines | Where-Object { $_.shortcut -eq $Engine } | Select-Object -First 1
    if (-not $Search) { throw "Failed to find search engine: $Engine" }

    # Build the search engine query
    $Query = $Search.url.Replace("%s", $EncodedQuery)
 
    # Launch the URL using the Start-Process cmdlet (opens the URL with the default browser)
    Start-Process $Query -ErrorAction Stop
}

# Register argument completer for the available search engines
Register-ArgumentCompleter -CommandName Search-Web -ParameterName Engine -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Script:SearchEngines | Where-Object { $_.shortcut -like "$wordToComplete*" } | ForEach-Object {
        New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $_.shortcut,
        $_.shortcut,
        "ParameterValue",
        $_.name
    }
}
