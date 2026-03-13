<#
.SYNOPSIS
    Switch between Light and Dark modes based on the current Windows Color Theme.
.DESCRIPTION
    This function determines the current Windows Color Theme and switches to the opposite theme.
    If the current theme is Dark, it switches to Light mode, and vice versa.
.EXAMPLE
    Switch-Theme
    This will check the current Windows Color Theme and switch to the opposite theme (Light to Dark or Dark to Light).
#>
function Switch-Theme {
    # Get the current Windows Color Theme as a boolean value (1 for Light, 0 for Dark)
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
