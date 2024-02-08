# --------
# REMINDER
# --------

# The path to the reminders folder in the Windows Task Scheduler
$Script:TaskPath = "\S7\Reminders"

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}
