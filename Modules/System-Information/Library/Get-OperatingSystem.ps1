<#
.SYNOPSIS
    Returns information about the operating system
.DESCRIPTION
    Returns information about the operating system
.EXAMPLE
    Get-OperatingSystem
#>
function Get-OperatingSystem() {
    $OS = Get-WmiObject -Class Win32_OperatingSystem
    $OS | Select-Object -Property @{
        Name       = "Name"
        Expression = { $_.Caption }
    },
    OSArchitecture,
    Version,
    BuildNumber,
    SerialNumber,
    InstallDate
}
