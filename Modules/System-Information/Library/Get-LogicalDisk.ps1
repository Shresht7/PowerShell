<#
.SYNOPSIS
    Retrieves information about logical disks on the system.
.DESCRIPTION
    This function uses the Win32_LogicalDisk class to get detailed information about the logical disks
    on the system, including their device IDs, drive types, file systems, free space, sizes, and more.
.EXAMPLE
    Get-LogicalDisk
    This command retrieves and displays information about all logical disks on the local system.
.OUTPUTS
    Win32_LogicalDisk
#>
function Get-LogicalDisk {
    Get-CimInstance -ClassName Win32_LogicalDisk
}
