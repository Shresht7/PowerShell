<#
.SYNOPSIS
    Imports a JSON file and converts it to a PowerShell object.
.DESCRIPTION
    Imports a JSON file and converts it to a PowerShell object.
.EXAMPLE
    Import-Json -Path "C:\config.json"
    This command imports the JSON file located at "C:\config.json" and outputs the resulting PowerShell object to the console.
.EXAMPLE
    $data = Import-Json -Path "C:\data.json"
    This command imports the JSON file located at "C:\data.json" and stores the resulting PowerShell object in the variable $data.
#>
function Import-Json(
    # Path to the JSON file
    [Parameter(Mandatory = $true)]
    [string] $Path
) {
    Get-Content -Path $Path | ConvertFrom-Json
}
