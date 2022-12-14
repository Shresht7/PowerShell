<#
.SYNOPSIS
    Sets a timer
.DESCRIPTION
    Starts a timer countdown
.EXAMPLE
    Set-Timer -TimeSpan (New-TimeSpan -Seconds 30)
    Sets a timer for 30 seconds
.EXAMPLE
    Set-Timer -TimeSpan (New-TimeSpan -Minutes 25) -ScriptBlock { Write-Host "Time's Up!" }
    Runs a timer for 25 minutes and then executes the script block
#>
function Set-Timer(
    [Parameter(Mandatory)]
    [timespan] $TimeSpan = (New-TimeSpan -Seconds 60),

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [scriptblock] $ScriptBlock
) {
    $Script:TimeSpan = $TimeSpan
    while ($Script:TimeSpan.TotalSeconds -gt 0) {
        Write-Host "Remaining: $(if ($Script:TimeSpan.TotalHours -gt 0) { "$($Script:TimeSpan.Hours)h" }) $(if ($Script:TimeSpan.TotalMinutes -gt 0) { "$($Script:TimeSpan.Minutes)m" }) $($Script:TimeSpan.Seconds)s"
        $Script:TimeSpan = New-TimeSpan -Seconds ($Script:TimeSpan.TotalSeconds - 1) 
        Start-Sleep -Seconds 1
        Clear-Host
    }

    if ($ScriptBlock) {
        $ScriptBlock.Invoke()
    }
}
