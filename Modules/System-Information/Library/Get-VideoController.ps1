<#
.SYNOPSIS
    Get information about the video controller (GPU)
.DESCRIPTION
    Get information about the video controller (GPU) like the name, driver version, video processor, video memory, etc.
.EXAMPLE
    Get-VideoController
    Shows information about the video controller (GPU)
.OUTPUTS
    Win32_VideoController
#>
function Get-VideoController {
    Get-CimInstance -ClassName Win32_VideoController
}
