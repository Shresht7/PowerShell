<#
.SYNOPSIS
    Get information about the BIOS
.DESCRIPTION
    Get information about the BIOS
.EXAMPLE
    Get-BIOS
#>
function Get-BIOS() {
    Get-CimInstance -ClassName Win32_BIOS
}
