function Invoke-Script($ScriptsLocation = "$HOME\Scripts") {
    . (Get-ChildItem $ScriptsLocation | Invoke-Fzf -Preview "bat --style=numbers --color=always {}")
}
Set-Alias script Invoke-Script

Export-ModuleMember -Function Invoke-Script
Export-ModuleMember -Alias script
