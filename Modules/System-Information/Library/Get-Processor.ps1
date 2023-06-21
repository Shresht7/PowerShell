<#
.SYNOPSIS
    Get information about the processor
.DESCRIPTION
    Get information about the processor
.EXAMPLE
    Get-Processor
#>
function Get-Processor() {
    Get-CimInstance -ClassName Win32_Processor
}
