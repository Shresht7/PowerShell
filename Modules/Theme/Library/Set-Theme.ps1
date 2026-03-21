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
.NOTES
    Author: Shresht Srivastav
    Version: 1.1
#>
function Set-Theme {
    [CmdletBinding(DefaultParameterSetName = "Light")]
    param(
        # Set the Windows theme to Light mode.
        [Parameter(ParameterSetName = "Light")]
        [Switch] $Light,

        # Set the Windows theme to Dark mode.
        [Parameter(ParameterSetName = "Dark")]
        [Switch] $Dark,

        # Specify which theme to set (Both, System, App).
        [ValidateSet("Both", "System", "App")]
        [string] $Target = "Both"
    )

    process {
        # Path to the Registry Entry for Windows theme
        $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        
        # Determine the value (1 for Light, 0 for Dark)
        $Value = if ($Light) { 1 } else { 0 }
        $ThemeName = if ($Light) { "Light" } else { "Dark" }

        try {
            if ($Target -in @("Both", "System")) {
                Set-ItemProperty -Path $RegPath -Name SystemUsesLightTheme -Value $Value -ErrorAction Stop
            }
            if ($Target -in @("Both", "App")) {
                Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value $Value -ErrorAction Stop
            }
            Write-Verbose "Windows theme set to $ThemeName mode (Target: $Target)."
        }
        catch {
            Write-Error "Failed to set theme: $_"
        }
    }
}
