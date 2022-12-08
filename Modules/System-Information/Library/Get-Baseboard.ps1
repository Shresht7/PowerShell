<#
.SYNOPSIS
    Get baseboard information
.DESCRIPTION
    Get baseboard information
.EXAMPLE
    Get-Baseboard
#>
function Get-Baseboard() {
    Get-WmiObject -Class Win32_BaseBoard
}
