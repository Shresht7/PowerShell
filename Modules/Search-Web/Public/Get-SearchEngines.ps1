<#
.SYNOPSIS
Retrieves search engine information from the Edge Web Data SQLite database.
.DESCRIPTION
This function reads search engine information from the specified Edge Web Data SQLite database and returns the results.
.PARAMETER Path
Path to the folder containing the Edge Web Data SQLite database. Defaults to the Edge default path.
.EXAMPLE
Get-SearchEngines -Path "C:\Path\To\Edge\Profile" -TableName "custom_search_engines"
#>
function Get-SearchEngines(
    # Path to the folder the Web Data Sqlite Database resides in
    [string] $Path = "$Env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"
) {

    if (!(Get-Command sqlite3.exe -ErrorAction SilentlyContinue)) {
        throw "Failed to find sqlite3.exe!"
    }

    # Create a copy of the Sqlite database
    $Source = Join-Path $Path "Web Data"
    $Destination = Join-Path $Env:TEMP "Edge Web Data"
    Copy-Item -Path $Source -Destination $Destination

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
 
    return sqlite3.exe $Destination "SELECT * FROM keywords;" | ConvertFrom-Csv -Delimiter "|" -Header $Headers
}
