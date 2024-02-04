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
    [string] $Query
)

# Prompt the user for the $Query, if not specified
if (-not $Query) {
    $Query = Read-Host -Prompt "Query"
}

# Invoke the cheat.sh API
$Response = Invoke-WebRequest -Uri "https://cheat.sh/$Query" 

# Write the response body to the console
$Response.Content
