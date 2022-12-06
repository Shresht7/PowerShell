<#
.SYNOPSIS
Reimports all modules
.DESCRIPTION
Resets by force re-importing the modules
.PARAMETER $Path
The directory that contains the modules. Defaults to the Documents\PowerShell\Modules directory
.EXAMPLE
Reset-Modules
Force resets all modules in the PowerShell module directory
.EXAMPLE
Reset-Modules "$HOME\Configs\PowerShell\Modules"
Force resets all modules in Configs\PowerShell\Modules directory
#>

param
(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = "$HOME\Documents\PowerShell\Modules",

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$ModuleNames
) 

process {
    if ($Path) {
        Get-ChildItem -Directory $Path | Import-Module -Force
    }
    else {
        $ModuleNames | Import-Module -Force
    }
}
