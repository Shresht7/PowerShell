<#
.SYNOPSIS
    Returns the last boot-up time
.DESCRIPTION
    Returns the last boot-up time for this computer
.EXAMPLE
    Get-LastBootUpTime
.OUTPUTS
    PSCustomObject with properties ComputerName, LastBootUpTime, Duration, Days, Hours, Minutes, Seconds, Milliseconds
#>
function Get-LastBootUpTime(
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "HostName", "Computer", "SystemName")]
    [string] $ComputerName = $Env:COMPUTERNAME
) {
    $LastBootUpTime = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName
        | Select-Object -Property LastBootUpTime).LastBootUpTime
    $Duration = New-TimeSpan -Start $LastBootUpTime -End (Get-Date)
    [PSCustomObject]@{
        ComputerName   = $ComputerName
        LastBootUpTime = $LastBootUpTime
        Duration       = $Duration
        Days           = $Duration.Days
        Hours          = $Duration.Hours
        Minutes        = $Duration.Minutes
        Seconds        = $Duration.Seconds
        Milliseconds   = $Duration.Milliseconds
    }
}
