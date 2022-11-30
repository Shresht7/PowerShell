<#
.SYNOPSIS
    Shows the clock
.DESCRIPTION
    Show the time and date. Refreshes every 1 second.
.EXAMPLE
    Show-Time
#>
function Show-Time() {
    Watch-Command { Get-Date } -Interval 1 -ClearHost
}
