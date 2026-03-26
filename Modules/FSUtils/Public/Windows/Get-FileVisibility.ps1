<#
.SYNOPSIS
    Gets the current visibility status of hidden files in Windows Explorer
.DESCRIPTION
    This function checks the current setting for hidden file visibility in Windows Explorer and returns $true if
    hidden files are currently visible, or $false if they are currently hidden.
.EXAMPLE
    Get-FileVisibility
    Returns $true if hidden files are currently visible, or $false if they are hidden
.NOTES
    This function reads the registry key that controls hidden file visibility and does not modify any settings or refresh the file explorer.
#>
function Get-FileVisibility {
    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $RegistryKey = "Hidden"
    $Current = Get-ItemProperty -Path $RegistryPath -Name $RegistryKey
    if ($Current.$RegistryKey -eq 1) { return $true } else { return $false }
}
