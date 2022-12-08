<#
.SYNOPSIS
    Returns information about the physical memory (RAM)
.DESCRIPTION
    Returns information about the physical memory (RAM)
.EXAMPLE
    Get-PhysicalMemory
#>
function Get-PhysicalMemory() {
    $MemoryBanks = Get-WmiObject -Class Win32_PhysicalMemory
    $MemoryBanks | Select-Object -Property SerialNumber,
    Tag,
    DeviceLocator,
    @{Name = "Capacity"; Expression = { $_.Capacity / 1Gb } },
    Speed,
    ConfiguredVoltage
    | Format-Table
}
