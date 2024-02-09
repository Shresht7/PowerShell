<#
.SYNOPSIS
    Creates a reminder using the Windows Task Scheduler
.DESCRIPTION
    Creates a reminder using the Windows Task Scheduler. The reminder will display a message at the specified time.
.EXAMPLE
    Set-Reminder -Message "Dinner" -At 8:45pm
    Creates a reminder for dinner at 8:45pm.
.EXAMPLE
    Set-Reminder -Message "Go to the meeting" -At (Get-Date).AddMinutes(30)
    Creates a reminder to go to the meeting in 30 minutes.
#>
function Set-Reminder(
    # The reminder message
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('For')]
    [string] $Message,

    # The time to be reminded at
    [Parameter(Mandatory)]
    [Alias("Time")]
    [datetime] $At
) {

    # Make a script-block to create a BurntToast notification
    $script = "{ New-BurntToastNotification -Text '$Message' }"

    # Create a scheduled task for the reminder
    $action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-NoProfile -Command `"& $script`""
    $trigger = New-ScheduledTaskTrigger -Once -At $At
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Description "Reminder: $Message"

    # Register the scheduled task under the S7\Reminders folder in the scheduler
    Register-ScheduledTask -TaskPath $Script:TaskPath -TaskName "Reminder_$(New-Guid)" -InputObject $task

}
