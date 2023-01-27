<#
.SYNOPSIS
    Execute a script-block periodically
.DESCRIPTION
    Periodically execute a script-block on a given time interval.
    This allows to see the program output change over time. By default the interval is set to 1 second.
    This script-block runs until explicitly stopped.
.EXAMPLE
    Watch-Command { Get-Date }
    Will execute `Get-Date` every second
.EXAMPLE
    Watch-Command { Get-Date } -Interval 60
    Will execute `Get-Date` every 60 seconds
#>
function Watch-Command(
    # The Script-Block to execute repeatedly
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [scriptblock] $ScriptBlock,

    # The update interval timespan (default 1 second)
    [int32] $Interval = 1,

    # Switch to clear the host screen on each tick
    [switch] $ClearHost
) {
    while ($True) {
        if ($ClearHost) { Clear-Host }
        $ScriptBlock.Invoke()
        Start-Sleep -Seconds $Interval
    }
}
