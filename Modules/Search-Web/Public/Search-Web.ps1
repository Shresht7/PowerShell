<#
.SYNOPSIS
    Search the web.
.DESCRIPTION
    Launches the default web-browser to do a web-search using a search-engine.
.EXAMPLE
    Search-Web 'PowerShell Documentation'
    Searches the web for 'PowerShell Documentation' using the default search engine.
.EXAMPLE
    Search-Web 'Microsoft PowerToys' bing
    Searches the web for 'Microsoft PowerToys' using the 'bing' search engine.
.EXAMPLE
    Search-Web -Engine github -Query 'Terminal'
    Searches GitHub for 'Terminal'.
.PARAMETER Query
    The search query to perform.
.PARAMETER Engine
    The search engine to use to perform the search (e.g., google, bing, github).
#>
function Search-Web {
    param(
        # The search query to perform
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Query,

        # The search engine to use to perform the search
        [string] $Engine = "google"
    )

    process {
        # Encode the query string (System.Net.WebUtility is available in PS5.1 and PS7)
        $EncodedQuery = [System.Net.WebUtility]::UrlEncode($Query)
    
        # Look for the search engine in the script-scoped variable
        if (-not $Script:SearchEngines) {
            Write-Error "Search engines list is not initialized. Please ensure the module is loaded correctly."
            return
        }

        $Search = $Script:SearchEngines | Where-Object { $_.shortcut -eq $Engine } | Select-Object -First 1
        
        if (-not $Search) {
            Write-Error "Failed to find search engine: $Engine"
            return
        }

        # Build the final search URL
        $TargetUrl = $Search.url.Replace("%s", $EncodedQuery)
    
        # Launch the URL using the Start-Process cmdlet
        try {
            Start-Process -FilePath $TargetUrl -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to launch browser for URL: $TargetUrl. Error: $_"
        }
    }
}

# Register argument completer for the available search engines
Register-ArgumentCompleter -CommandName Search-Web -ParameterName Engine -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    if ($Script:SearchEngines) {
        $Script:SearchEngines | Where-Object { $_.shortcut -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.shortcut,
                $_.shortcut,
                "ParameterValue",
                $_.name
            )
        }
    }
}
