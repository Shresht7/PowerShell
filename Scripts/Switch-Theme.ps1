<#
.SYNOPSIS
    Switches the Windows theme based on the time of day
.DESCRIPTION
    Switches the Windows theme based on the time of day
#>

# Get the current time
$date = Get-Date

# The the time of day is between 06 and 12, set the Light theme
if ($date.Hour -ge 6 -and $date.Hour -lt 12) {
    Set-Theme -Light
}
# Otherwise, set the Dark theme
else {
    Set-Theme -Dark
}
