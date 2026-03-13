<#
.SYNOPSIS
    Set the Windows theme to Light or Dark mode.
.DESCRIPTION
    This function allows you to change the Windows theme to either Light mode or Dark mode.
    It modifies the registry entries responsible for the theme settings.
.EXAMPLE
    Set-Theme -Light
    Changes the Windows theme to Light mode.
.EXAMPLE
    Set-Theme -Dark
    Changes the Windows theme to Dark mode.
.EXAMPLE
    Set-Theme -Light -Target System
    Changes the system theme to Light mode, while keeping the app theme unchanged.
.EXAMPLE
    Set-Theme -Dark -Target App
    Changes the app theme to Dark mode, while keeping the system theme unchanged.
.EXAMPLE
    Set-Theme -Light -Target Both
    Changes both the system and app themes to Light mode. This is the default behavior if no target is specified.
.NOTES
    Author: Shresht Srivastav
    Version: 1.0
    Date: 18th October 2023
#>
function Set-Theme(
    # Set the Windows theme to Light mode.
    [Parameter(ParameterSetName = "Light")]
    [Switch] $Light,

    # Set the Windows theme to Dark mode.
    [Parameter(ParameterSetName = "Dark")]
    [Switch] $Dark,

    # Specify which theme to set (Both, System, App).
    [ValidateSet("Both", "System", "App")]
    [string] $Target = "Both"
) {
    # Path to the Registry Entry for Windows theme
    $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # If the "Light" switch was passed, switch to light mode
    if ($Light) {
        if ($Target -ieq "Both" -or $Target -ieq "System") {
            Set-ItemProperty -Path $RegPath -Name SystemUsesLightTheme -Value 1
        }
        if ($Target -ieq "Both" -or $Target -ieq "App") {
            Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value 1
        }
        Write-Host "Windows theme set to Light mode."
    }
    
    # If the "Dark" switch was passed, switch to dark mode
    elseif ($Dark) {
        if ($Target -ieq "Both" -or $Target -ieq "System") {
            Set-ItemProperty -Path $RegPath -Name SystemUsesLightTheme -Value 0
        }
        if ($Target -ieq "Both" -or $Target -ieq "App") {
            Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value 0
        }
        Write-Host "Windows theme set to Dark mode."
    }
    else {
        Write-Host "No theme option selected. Use -Light or -Dark to set the theme."
    }
}
