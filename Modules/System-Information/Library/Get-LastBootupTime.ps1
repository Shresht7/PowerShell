<#
.SYNOPSIS
    Returns the last boot-up time
.DESCRIPTION
    Returns the last boot-up time for this computer
.EXAMPLE
    Get-LastBootUpTime
#>
function Get-LastBootUpTime(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $ComputerName = $Env:COMPUTERNAME
) {
    $LastBootUpTime = (Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime).LastBootUpTime
    [PSCustomObject]@{
        ComputerName   = $ComputerName
        LastBootUpTime = $LastBootUpTime
    }
}
