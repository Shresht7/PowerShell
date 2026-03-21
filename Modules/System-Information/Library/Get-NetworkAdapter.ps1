<#
.SYNOPSIS
    Retrieves information about the network adapters on the system.
.DESCRIPTION
    This function uses the Win32_NetworkAdapter class to get detailed information about the network adapters
    installed on the system, including their names, manufacturers, MAC addresses, speeds, and more.
.EXAMPLE
    Get-NetworkAdapter
    This command retrieves and displays information about all network adapters on the local system.
.OUTPUTS
    Win32_NetworkAdapter
#>
function Get-NetworkAdapter {
    Get-CimInstance -ClassName Win32_NetworkAdapter
}
