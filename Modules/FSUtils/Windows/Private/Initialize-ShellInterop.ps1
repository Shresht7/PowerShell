<#
.SYNOPSIS
    Initializes the Shell Interop
.DESCRIPTION
    Loads the Shell interop types if not already loaded.
    Needed for Shell operations.
    Only loaded once.
#>
function Initialize-ShellInterop {
    if ('PSFSUtils.Shell' -as [type]) { return }
    Add-Type -Path (Join-Path $PSScriptRoot "Shell.cs")
}
