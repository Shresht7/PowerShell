<#
.SYNOPSIS
    Returns information about the operating system.
.DESCRIPTION
    Returns information about the operating system installed on the system.
.EXAMPLE
    Get-OperatingSystem
#>
function Get-OperatingSystem {
    # Retrieve information about the operating system
    $OS = Get-CimInstance -ClassName Win32_OperatingSystem

    # Select the desired properties
    $OSInfo = $OS | Select-Object -Property @{
        Name       = "Name"
        Expression = { $_.Caption }
    },
    OSArchitecture,
    Version,
    BuildNumber,
    SerialNumber,
    InstallDate

    # Return the operating system information
    $OSInfo
}
