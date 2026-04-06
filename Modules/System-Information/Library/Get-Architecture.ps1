<#
.SYNOPSIS
    Gets the architecture of the operating system
.DESCRIPTION
    Retrieves the architecture of the operating system (e.g., x86, x64, ARM) using the Win32_OperatingSystem class.
.EXAMPLE
    Get-Architecture
    Returns the architecture of the operating system, such as "64-bit" or "32-bit".
.EXAMPLE
    arch
    Using the alias "arch" to get the architecture of the operating system.
.NOTES
    This function relies on the Win32_OperatingSystem class, which is available on Windows systems.
    Meant to mimic the behavior of the "arch" coreutils command in Unix-like systems.
#>
function Get-Architecture {
    (Get-CimInstance -Class Win32_OperatingSystem).OSArchitecture
}

Set-Alias -Name arch -Value Get-Architecture
