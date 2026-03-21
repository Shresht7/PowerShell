<#
.SYNOPSIS
    Retrieves search engine information from a Chromium browser's Web Data SQLite database.
.DESCRIPTION
    This function reads search engine information from the specified browser's SQLite database and returns the results.
.PARAMETER Path
    Path to the folder containing the Web Data SQLite database.
.PARAMETER Browser
    The name of the browser to retrieve search engines for (Edge, Chrome, Brave, Vivaldi).
.EXAMPLE
    Get-SearchEngines
.EXAMPLE
    Get-SearchEngines -Browser "Chrome"
#>
function Get-SearchEngines {
    [CmdletBinding(DefaultParameterSetName = "Browser")]
    param(
        # Path to the folder the Web Data Sqlite Database resides in
        [Parameter(ParameterSetName = "Path")]
        [string] $Path,

        # Name of the browser to retrieve search engines for
        [Parameter(ParameterSetName = "Browser")]
        [ValidateSet("Edge", "Chrome")]
        [string] $Browser = "Edge"
    )

    process {
        if (-not (Get-Command "sqlite3.exe" -ErrorAction SilentlyContinue)) {
            Write-Error "Failed to find 'sqlite3.exe'. Please ensure it is in your PATH."
            return
        }

        # Determine the final database path
        $ProfilePath = if ($PSCmdlet.ParameterSetName -eq "Path") { 
            $Path 
        }
        else { 
            Get-BrowserPath -Browser $Browser -Type Profile
        }

        # Create a copy of the Sqlite database to avoid lock issues
        $Source = Join-Path $ProfilePath "Web Data"
        if (-not (Test-Path $Source)) {
            Write-Error "Web Data database not found at $Source"
            return
        }

        $Destination = Join-Path $Env:TEMP "Browser_Web_Data_Copy"
        try {
            Copy-Item -Path $Source -Destination $Destination -Force -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to copy browser database: $_"
            return
        }

        $Headers = @(
            "id", # INTEGER
            "short_name", # VARCHAR
            "keyword", # VARCHAR
            "favicon_url", # VARCHAR
            "url", # VARCHAR
            "salfe_for_autoreplace", # INTEGER
            "originating_url", # VARCHAR
            "date_created", # INTEGER
            "usage_count", # INTEGER
            "input_encodings", # VARCHAR
            "suggest_url", # VARCHAR
            "prepopulate_id", # INTEGER
            "created_by_policy", # INTEGER
            "last_modified", # INTEGER
            "sync_guid", # VARCHAR
            "alternate_urls", # VARCHAR
            "image_url", # VARCHAR
            "search_url_post_params", # VARCHAR
            "suggest_url_post_params", # VARCHAR
            "image_url_post_params", # VARCHAR
            "new_tab_url", # VARCHAR
            "last_visited", # INTEGER
            "created_from_play_api", # INTEGER
            "is_active", # INTEGER
            "starter_pack_id", # INTEGER
            "enforced_by_policy" # INTEGER
        )
    
        try {
            return sqlite3.exe $Destination "SELECT * FROM keywords;" | ConvertFrom-Csv -Delimiter "|" -Header $Headers
        }
        catch {
            Write-Error "Failed to query the database using sqlite3. Error: $_"
        }
        finally {
            if (Test-Path $Destination) { Remove-Item $Destination -Force }
        }
    }
}
