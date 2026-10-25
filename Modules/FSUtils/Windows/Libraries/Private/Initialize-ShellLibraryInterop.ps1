<#
.SYNOPSIS
    Compiles the shell interop types on first use
.DESCRIPTION
    Loads ShellLibrary.cs the first time a command needs it,
    so importing the module stays fast. Safe to call repeatedly.
#>
function Initialize-ShellLibraryInterop {
    if ('FSUtils.WindowsLibraries.ShellLibraryInterop' -as [type]) { return }
    Initialize-ShellInterop # ensure shell types are loaded
    Add-Type -Path (Join-Path $PSScriptRoot 'ShellLibrary.cs')
}
