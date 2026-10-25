<#
.SYNOPSIS
    Shows whether desktop icons are currently visible or hidden
.DESCRIPTION
    This function checks the current setting for desktop icon visibility in Windows
    and returns $true if they are visible and $false if they are hidden.
.EXAMPLE
    Get-DesktopIconVisibility
    Returns $true if desktop icons are currently visible, or $false if they are hidden
.NOTES
    This function reads the registry key that controls desktop icon visibility
    and does not modify any settings or refresh the file explorer.
#>
function Get-DesktopIconVisibility {
    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $RegistryKey = "HideIcons"
    $Current = Get-ItemProperty -Path $RegistryPath -Name $RegistryKey
    if ($Current.$RegistryKey -eq 0) { return $true } else { return $false }
}
