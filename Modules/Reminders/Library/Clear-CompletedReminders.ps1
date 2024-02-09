<#
.SYNOPSIS
    Clears all completed reminders from the scheduled tasks.
.DESCRIPTION
    The Clear-CompletedReminders function retrieves all reminders from the scheduled tasks under the S7\Reminders\ folder
    and removes (unregisters) the ones that have already been triggered.
    It uses the Get-Reminders and Remove-Reminder functions to achieve this.
.EXAMPLE
    Clear-CompletedReminders
    Removes all reminders that have already been triggered.
#>
function Clear-CompletedReminders() {
    
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Get all reminders that have already been triggered
    $reminders = Get-Reminder | Where-Object { $_.At -lt (Get-Date) }

    # Remove (unregister) all the triggered reminders from the scheduled tasks
    foreach ($reminder in $reminders) {
        if ($PSCmdlet.ShouldProcess("Remove reminder: $($reminder.Message)")) {
            $reminder | Remove-Reminder
        }
    }
}
