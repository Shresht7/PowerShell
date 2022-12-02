<#
.SYNOPSIS
    Get baseboard information
.DESCRIPTION
    Get baseboard information
#>
function Get-Baseboard() {
    Get-WmiObject -Class Win32_BaseBoard
}
