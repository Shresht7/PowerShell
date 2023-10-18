<#
.SYNOPSIS
    Get the current Windows theme (Light or Dark mode).
.DESCRIPTION
    This function retrieves the current Windows theme, which can be either
    Light or Dark mode.

.PARAMETER AsValue
    If specified, returns the theme as a boolean value (True for Light, False for Dark).

.PARAMETER AsString
    If specified, returns the theme as a string ("Light" or "Dark").

.EXAMPLE
    Get-Theme -AsValue
    Retrieves the current Windows theme as a boolean value (True for Light, False for Dark).

.EXAMPLE
    Get-Theme -AsString
    Retrieves the current Windows theme as a string ("Light" or "Dark").

.NOTES
    Author: Shresht Srivastav
    Version: 1.0
    Date: 18th October 2023
#>
function Get-Theme {
    [CmdletBinding(DefaultParameterSetName = "AsString")]
    param(
        [Parameter(ParameterSetName = "AsValue")]
        [switch] $AsValue,
        [Parameter(ParameterSetName = "AsString")]
        [switch] $AsString
    )

    # Path to the Registry Entry for Windows theme
    $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # Get the current theme value from the registry
    $currentTheme = Get-ItemPropertyValue -Path $RegPath -Name SystemUsesLightTheme

    if ($AsValue) {
        return $currentTheme
    }
    else {
        return $currentTheme ? "Light" : "Dark"
    }
}
