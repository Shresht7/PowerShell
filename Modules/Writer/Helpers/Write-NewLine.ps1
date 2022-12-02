<#
.SYNOPSIS
    Writes new lines
.DESCRIPTION
    Writes one or more new lines
.PARAMETER $Count
The number of newlines to add (default: 1)
.EXAMPLE
Write-NewLine
Writes a newline to the host
Write-NewLine -Count 5
Writes 5 new lines to the host
#>
function Write-NewLine([int]$Count = 1) {
    for ($i = 0; $i -lt $Count; $i++) {
        Write-Host ""
    }
}
