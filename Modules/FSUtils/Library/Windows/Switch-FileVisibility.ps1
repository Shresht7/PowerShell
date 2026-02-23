<#
.SYNOPSIS
    Toggles the visibility of hidden files in Windows Explorer
.DESCRIPTION
    This function checks the current setting for hidden file visibility in Windows Explorer and toggles it. 
    If hidden files are currently visible, it will hide them, and if they are currently hidden, it will make them visible.
.EXAMPLE
    Switch-FileVisibility
    Toggles the visibility of hidden files in Windows Explorer
.NOTES
    This function modifies the registry key that controls hidden file visibility
     and then calls `Invoke-ExplorerRefresh` to refresh the file explorer settings, 
    ensuring that the changes take effect immediately.
#>
function Switch-FileVisibility {
    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $Current = Get-ItemProperty -Path $RegistryPath -Name Hidden

    if ($Current.Hidden -eq 1) {
        Set-ItemProperty -Path $RegistryPath -Name Hidden -Value 2
        Write-Output "Hidden files are now hidden!"
    }
    else {
        Set-ItemProperty -Path $RegistryPath -Name Hidden -Value 1
        Write-Output "Hidden files are now visible!"
    }

    Invoke-ExplorerRefresh # Refresh the file explorer to reflect the changes
}
