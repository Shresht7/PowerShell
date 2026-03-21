<#
.SYNOPSIS
    Get information about the BIOS.
.DESCRIPTION
    Retrieves information about the BIOS from the system.
.EXAMPLE
    Get-BIOS
#>
function Get-BIOS {
    Get-CimInstance -ClassName Win32_BIOS
}
