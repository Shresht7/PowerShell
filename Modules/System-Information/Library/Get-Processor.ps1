<#
.SYNOPSIS
    Get information about the processor.
.DESCRIPTION
    Retrieves processor information from the system.
.EXAMPLE
    Get-Processor
#>
function Get-Processor {
    Get-CimInstance -ClassName Win32_Processor
}
