<#
.SYNOPSIS
    Get the current Windows Color Theme (Light or Dark Mode).
.DESCRIPTION
    This function retrieves the current Windows  Color Theme, which can be either Light or Dark.
.EXAMPLE
    Get-Theme -AsValue
    Retrieves the current Windows Color Theme as a boolean value (True for Light, False for Dark).    
.EXAMPLE
    Get-Theme -AsString
    Retrieves the current Windows Color Theme as a string ("Light" or "Dark").
.NOTES
    Author: Shresht Srivastav
    Version: 1.0
    Date: 18th October 2023
#>
function Get-Theme {
    [CmdletBinding(DefaultParameterSetName = "AsString")]
    param(
        # If specified, returns the theme as a boolean value (True for Light, False for Dark)
        [Parameter(ParameterSetName = "AsValue")]
        [switch] $AsValue,
        # If specified, returns the theme as a string ("Light" or "Dark")
        [Parameter(ParameterSetName = "AsString")]
        [switch] $AsString
    )

    # Path to the Registry Entry for Windows theme
    $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # Get the current theme value from the registry
    $currentTheme = Get-ItemPropertyValue -Path $RegPath -Name SystemUsesLightTheme

    # Return the theme based on the specified parameter set
    if ($AsValue) {
        return $currentTheme
    }
    else {
        return $currentTheme ? "Light" : "Dark"
    }
}
