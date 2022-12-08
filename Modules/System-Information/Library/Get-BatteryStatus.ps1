<#
.SYNOPSIS
    Get status of the battery
.DESCRIPTION
    Get status of the battery like the battery percentage and time remaining
.EXAMPLE
    Get-BatteryStatus
    Shows information about the battery
#>
function Get-BatteryStatus() {
    Add-Type -AssemblyName System.Windows.Forms

    $PowerStatus = [System.Windows.Forms.SystemInformation]::PowerStatus

    $PowerStatus | Select-Object -Property *,
    @{
        Name       = "BatteryLifePercentage"
        Expression = { [int]($_.BatteryLifePercent * 100) }
    },
    @{
        Name       = "Time Remaining (Minutes)"
        Expression = { $_.BatteryLifeRemaining / 60 }
    }
}
