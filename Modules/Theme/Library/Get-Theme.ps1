<#
.SYNOPSIS
    Get the current Windows Color Theme (Light or Dark Mode).
.DESCRIPTION
    This function retrieves the current Windows Color Theme for System and/or Apps.
.EXAMPLE
    Get-Theme
    Returns a custom object with System and App theme status.
.EXAMPLE
    Get-Theme -Target System -AsString
    Returns "Light" or "Dark" for the System theme.
.EXAMPLE
    Get-Theme -AsValue
    Returns 1 (Light) or 0 (Dark) for both System and App themes.
.NOTES
    Author: Shresht Srivastav
    Version: 1.1
#>
function Get-Theme {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        # Specify which theme to get (Both, System, App).
        [ValidateSet("Both", "System", "App")]
        [string] $Target = "Both",

        # If specified, returns the theme as a numeric value (1 for Light, 0 for Dark)
        [Parameter(ParameterSetName = "AsValue")]
        [switch] $AsValue,

        # If specified, returns the theme as a boolean value (True for Light, False for Dark)
        [Parameter(ParameterSetName = "AsBoolean")]
        [switch] $AsBoolean,

        # If specified, returns the theme as a string ("Light" or "Dark")
        [Parameter(ParameterSetName = "AsString")]
        [switch] $AsString
    )

    process {
        $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        
        try {
            $SystemTheme = Get-ItemPropertyValue -Path $RegPath -Name SystemUsesLightTheme -ErrorAction Stop
            $AppTheme = Get-ItemPropertyValue -Path $RegPath -Name AppsUseLightTheme -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to retrieve theme settings: $_"
            return
        }

        # Helper to format the value based on switches
        $Formatter = {
            param($Val)
            if ($AsValue) { return $Val }
            if ($AsBoolean) { return [bool]$Val }
            if ($AsString) { return if ($Val) { "Light" } else { "Dark" } }
            # Default format: Return formatted string if single target, or object if 'Both' default
            return if ($Val) { "Light" } else { "Dark" }
        }

        if ($Target -eq "System") {
            return & $Formatter $SystemTheme
        }
        elseif ($Target -eq "App") {
            return & $Formatter $AppTheme
        }
        else {
            # Both
            $Result = [PSCustomObject]@{
                System = (& $Formatter $SystemTheme)
                App    = (& $Formatter $AppTheme)
            }
            return $Result
        }
    }
}
