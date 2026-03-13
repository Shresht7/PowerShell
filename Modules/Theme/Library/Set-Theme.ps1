<#
.SYNOPSIS
    Set the Windows theme to Light or Dark mode.
.DESCRIPTION
    This function allows you to change the Windows theme to either Light mode or Dark mode.
    It modifies the registry entries responsible for the theme settings.

.PARAMETER Light
    Set the Windows theme to Light mode.

.PARAMETER Dark
    Set the Windows theme to Dark mode.

.EXAMPLE
    Set-Theme -Light
    Changes the Windows theme to Light mode.

.EXAMPLE
    Set-Theme -Dark
    Changes the Windows theme to Dark mode.

.NOTES
    Author: Shresht Srivastav
    Version: 1.0
    Date: 18th October 2023
#>
function Set-Theme(
    [Parameter(ParameterSetName = "Light")]
    [Switch] $Light,
    [Parameter(ParameterSetName = "Dark")]
    [Switch] $Dark
) {
    # Path to the Registry Entry for Windows theme
    $RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # If the "Light" switch was passed, switch to light mode
    if ($Light) {
        Set-ItemProperty -Path $RegPath -Name SystemUsesLightTheme -Value 1
        Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value 1
        Write-Host "Windows theme set to Light mode."
    }
    
    # If the "Dark" switch was passed, switch to dark mode
    elseif ($Dark) {
        Set-ItemProperty -Path $RegPath -Name SystemUsesLightTheme -Value 0
        Set-ItemProperty -Path $RegPath -Name AppsUseLightTheme -Value 0
        Write-Host "Windows theme set to Dark mode."
    }
    else {
        Write-Host "No theme option selected. Use -Light or -Dark to set the theme."
    }
}
