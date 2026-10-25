function Initialize-ShellInterop {
    if ('PSFSUtils.Shell.ShellItems' -as [type]) { return }
    Add-Type -Path (Join-Path $PSScriptRoot '..\bin\PSFSUtils.Shell.dll')
}
