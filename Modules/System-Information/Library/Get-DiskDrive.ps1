<#
.SYNOPSIS
    Get information about the disk drives
.DESCRIPTION
    Get information about the disk drives like the model, manufacturer, size, partitions, etc.
.EXAMPLE
    Get-DiskDrive
    Shows information about the disk drives
.OUTPUTS
    Win32_DiskDrive
#>
function Get-DiskDrive {
    Get-CimInstance -ClassName Win32_DiskDrive
}
