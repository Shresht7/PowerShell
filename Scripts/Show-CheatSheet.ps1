<#
.SYNOPSIS
    Invoke the cheat.sh API
.DESCRIPTION
    Invoke the cheat.sh API to get cheat sheets for various programming languages and tools.
    The API is a simple HTTP GET request to https://cheat.sh/<query>.
.EXAMPLE
    Show-CheatSheet -Query "bash"
    Shows the cheat sheet for bash
.EXAMPLE
    Show-CheatSheet -Query ":intro"
    Shows the introduction to cheat.sh
#>

[CmdletBinding()]
Param(
    # The query to search for in the cheat.sh API
    [Parameter(ValueFromRemainingArguments = $true)]
    [string] $Query = ":intro"
)

$ProgrammingLanguages = @(
    "javascript",
    "typescript",
    "go",
    "rust",
    "python",
    "bash",
    "powershell",
    "sql"
)

# If the first argument is a programming language, extract it from the query
$Language, $RemainingQuery = $Query -split " ", 2
if ($ProgrammingLanguages -contains $Language) {
    $Query = $RemainingQuery
}
else {
    $Language = $null
}

# URL encode the query
$Query = [System.Web.HttpUtility]::UrlEncode($Query)

# Determine the cheat.sh url
$URL = if ($Language) {
    "https://cheat.sh/$Language/$Query"
}
else {
    "https://cheat.sh/$Query"
}
Write-Verbose "Invoke-WebRequest: $URL"

# Invoke the cheat.sh API and get the response
$Response = Invoke-WebRequest -Uri $URL -UseBasicParsing

# Write the response body to the console
$Response.Content
