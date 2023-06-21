<#
.SYNOPSIS
    Returns information about the physical memory (RAM).
.DESCRIPTION
    Returns information about the physical memory (RAM) installed in the system.
.EXAMPLE
    Get-PhysicalMemory
#>
function Get-PhysicalMemory {
    # Retrieve information about physical memory
    $MemoryBanks = Get-CimInstance -ClassName Win32_PhysicalMemory

    # Select the desired properties and calculate the memory capacity in GB
    $MemoryInfo = $MemoryBanks | Select-Object -Property SerialNumber, Tag, DeviceLocator, 
    @{Name = "Capacity (GB)"; Expression = { $_.Capacity / 1GB } }, Speed, ConfiguredVoltage

    # Return the memory information
    $MemoryInfo
}
