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
