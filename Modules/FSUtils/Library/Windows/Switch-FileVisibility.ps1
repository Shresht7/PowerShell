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
     and then calls `Sync-ExplorerSettings` to refresh the file explorer settings, 
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

    Sync-ExplorerSettings # Refresh the file explorer to reflect the changes
}

<#
.SYNOPSIS
    Synchronizes the file explorer settings
.DESCRIPTION
    Notifies the system that the environment has changed, 
    causing it to refresh and synchronize the file explorer settings
.NOTES
    This is necessary after changing the file visibility settings, 
    as the file explorer does not automatically refresh to reflect the changes
#>
function Sync-ExplorerSettings {
    # Refresh all open file explorer windows to reflect the changes
    $shell = New-Object -ComObject Shell.Application
    foreach ($window in $shell.Windows()) {
        try {
            # Refresh the window if it's an explorer window
            if ($window.Name -eq "File Explorer") {
                $window.Refresh()
            }
        }
        catch {
            # Ignore any non-explorer windows or errors that may occur during refresh
        }
    }

}
