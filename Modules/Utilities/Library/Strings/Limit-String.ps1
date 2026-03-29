<#
.SYNOPSIS
    Filters the output based on the keyword retaining the PowerShell object format.
.DESCRIPTION
    Filters the output based on the keyword retaining the PowerShell object format.
.EXAMPLE
    Get-Service | Limit-String "running"
    Filters the output of Get-Service that only contain "running"
#>
function Limit-String(
    # The string to search for
    [Parameter(Mandatory, Position = 0)]
    [string] $Keyword,

    # The text to filter
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)] 
    $Text
) {
    if ($Text -isnot [string]) {
        $Text = $Text | Format-Table -AutoSize | Out-String -Stream | Select-Object -Skip 3
    }
    $Text | Where-Object { $_ -like "*$Keyword*" }
}

Set-Alias Limit-String grep
