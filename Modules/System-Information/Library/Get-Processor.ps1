<#
.SYNOPSIS
    Get information about the processor
.DESCRIPTION
    Get information about the processor
#>
function Get-Processor() {
    Get-WmiObject -Class Win32_Processor
}
