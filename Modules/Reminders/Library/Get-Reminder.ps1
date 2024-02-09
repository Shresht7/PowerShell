<#
.SYNOPSIS
    Retrieves reminders from scheduled tasks.
.DESCRIPTION
    The Get-Reminder function retrieves reminders from scheduled tasks under the S7\Reminders folder.
    It can filter the tasks based on a specified pattern using the Like parameter.
.OUTPUTS
    [System.Management.Automation.PSCustomObject]
    A custom object is returned for each task, containing the following properties:
    - ID: The task name.
    - Message: The reminder message extracted from the task description.
    - At: The start time of the task trigger.
    - State: The state of the task.
.EXAMPLE
    Get-Reminder
    Retrieves all reminders.
.EXAMPLE
    Get-Reminder -Like "*Meeting*"
    Retrieves all reminders with task names containing the word "Meeting".
#>
function Get-Reminder(
    # Specifies a pattern to filter the tasks. Only tasks with names matching the pattern will be returned.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Pattern")]
    [string] $Like
) {

    # Get all the scheduled tasks under the S7\Reminders folder
    $tasks = Get-ScheduledTask -TaskPath $Script:TaskPath*
    
    # If the Like parameter is specified, filter the tasks
    if ($Like) {
        $tasks = $tasks | Where-Object { $_.TaskName -like $Like }
    }
    
    # Create a custom object for each task
    $tasks | ForEach-Object {
        [PSCustomObject]@{
            ID      = $_.TaskName
            Message = $_.Description -replace "Reminder: "
            At      = [DateTime]::Parse($_.Triggers[0].StartBoundary)
            State   = $_.State
        }
    }

}
