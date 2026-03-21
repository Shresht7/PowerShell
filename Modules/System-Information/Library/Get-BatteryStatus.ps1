<#
.SYNOPSIS
    Get status of the battery.
.DESCRIPTION
    Retrieves information about the battery status, including percentage and estimated run time.
.EXAMPLE
    Get-BatteryStatus
    Shows information about the battery.
.OUTPUTS
    CimInstance#Win32_Battery
#>
function Get-BatteryStatus {
    $Battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue

    if (-not $Battery) {
        Write-Warning "No battery detected or unable to retrieve battery status."
        return
    }

    $Battery | Select-Object -Property *,
    @{
        Name       = "BatteryLifePercentage"
        Expression = { $_.EstimatedChargeRemaining }
    },
    @{
        Name       = "Time Remaining (Minutes)"
        Expression = { if ($_.EstimatedRunTime -ne 71582788) { $_.EstimatedRunTime } else { $null } }
    }
}
