<#
.SYNOPSIS
    Removes the given reminder from the scheduled tasks.
.DESCRIPTION
    The Remove-Reminder function retrieves a reminder from the scheduled task under the `S7\Reminders\` folder
    and removes (unregisters) it.
.EXAMPLE
    Remove-Reminder -Name "Reminder_0ec8675c-4b30-463c-950b-627c27018259"
    Removes the given reminder from the `S7\Reminders\` tasks folder
.EXAMPLE
    Get-Reminder | Remove-Reminder
    Removes all reminders from the `\S7\Reminders` tasks folder
.EXAMPLE
    Get-Reminder | Remove-Reminder -WhatIf
    You can use the -WhatIf and -Confirm parameters!
#>
function Remove-Reminder {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The reminder to remove
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ID')]
        [string] $Name
    )


    # Process every item in the pipeline. This allows us to do stuff
    # like Get-Reminder | Remove-Reminder to remove all reminders
    process {
        $task = Get-ScheduledTask -TaskPath $Script:TaskPath -TaskName $Name
        if ($task) {
            # If the task exists, then proceed to remove (unregister) it
            if ($PSCmdlet.ShouldProcess('Remove')) {
                $task | Unregister-ScheduledTask
            }
        }
    }

}
