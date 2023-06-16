<#
.SYNOPSIS
    Shows the clock displaying the current time and date in the console.
.DESCRIPTION
    Show the time and date. Refreshes every 1 second.
.EXAMPLE
    Show-Clock
    Displays the current time and date in the console.
#>
function Show-Clock() {
    Clear-Host
    Watch-Command { Get-Date } -Interval 1 -ClearHost
}
