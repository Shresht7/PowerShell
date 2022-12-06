<#
.SYNOPSIS
    Starts an application
.DESCRIPTION
    Start an application from the shell:AppsFolder
.EXAMPLE
    Start-App -Name Clock
    Start the Windows Clock application
.EXAMPLE
    Get-StartApps | Invoke-Fzf | Start-App
    Interactively select the app using fzf and start it
#>
function Start-App(
    # Name of the Application. (Use `Get-StartApps` to get a list of apps)
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]$Name
) {
    $App = Get-StartApps | Where-Object { $_.Name -eq $Name }
    if (-Not $App) { return }
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\$(($App).AppId)"
}

Export-ModuleMember -Function Start-App
