<#
.SYNOPSIS
    Switch between Light and Dark modes based on the current Windows theme.
.DESCRIPTION
    This function determines the current Windows theme and switches to the opposite theme.
    If the current theme is Dark, it switches to Light mode, and vice versa.
#>
function Switch-Theme {
    # Get the current Windows theme as a boolean value (True for Light, False for Dark)
    $currentThemeValue = Get-Theme -AsValue

    # If the current theme is Dark, switch to Light mode
    if ($currentThemeValue -eq 0) {
        Set-Theme -Light
    }
    # If the current theme is Light, switch to Dark mode
    else {
        Set-Theme -Dark
    }
}
