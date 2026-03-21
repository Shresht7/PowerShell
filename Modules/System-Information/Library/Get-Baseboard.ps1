<#
.SYNOPSIS
    Get baseboard information
.DESCRIPTION
    Get baseboard information
.EXAMPLE
    Get-Baseboard
#>
function Get-Baseboard() {
    Get-CimInstance -ClassName Win32_BaseBoard
}
