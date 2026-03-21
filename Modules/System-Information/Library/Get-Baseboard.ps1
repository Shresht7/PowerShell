<#
.SYNOPSIS
    Get baseboard information.
.DESCRIPTION
    Retrieves motherboard information from the system.
.EXAMPLE
    Get-Baseboard
#>
function Get-Baseboard {
    Get-CimInstance -ClassName Win32_BaseBoard
}
