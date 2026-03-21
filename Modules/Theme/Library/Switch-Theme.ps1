<#
.SYNOPSIS
    Switch between Light and Dark modes based on the current Windows Color Theme.
.DESCRIPTION
    This function determines the current Windows Color Theme (System) and switches to the opposite theme.
    If the current theme is Dark, it switches to Light mode, and vice versa.
.EXAMPLE
    Switch-Theme
    This will check the current System Theme and switch to the opposite theme.
.EXAMPLE
    Switch-Theme -Target App
    This will check the current App Theme and switch it to the opposite theme.
.NOTES
    Author: Shresht Srivastav
    Version: 1.1
#>
function Switch-Theme {
    [CmdletBinding()]
    param(
        # Specify which theme to switch (Both, System, App).
        [ValidateSet("Both", "System", "App")]
        [string] $Target = "Both"
    )

    process {
        # Determine which theme to check for the current state
        # If Target is 'Both', we check 'System' as the primary indicator
        $CheckTarget = if ($Target -eq "App") { "App" } else { "System" }
        
        # Get the current theme value (1 for Light, 0 for Dark)
        $IsLight = Get-Theme -Target $CheckTarget -AsBoolean

        # If currently Light, switch to Dark. If Dark, switch to Light.
        if ($IsLight) {
            Set-Theme -Dark -Target $Target
        }
        else {
            Set-Theme -Light -Target $Target
        }
    }
}
