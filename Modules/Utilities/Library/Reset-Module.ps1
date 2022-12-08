<#
.SYNOPSIS
    Reimports all modules
.DESCRIPTION
    Resets by force re-importing the modules
.PARAMETER $Path
    The directory that contains the modules. Defaults to the "$HOME\PowerShell\Modules" directory
.EXAMPLE
    Reset-Modules
    Force resets all modules in the PowerShell module directory
.EXAMPLE
    Reset-Modules -Path "$HOME\Some\Other\PowerShell\Modules"
    Force resets all modules in "$HOME\Some\Other\PowerShell\Modules" directory
#>
function Reset-Module(
    # Path to the modules directory
    [Parameter(ParameterSetName = "Path")]
    [string] $Path = "$HOME\PowerShell\Modules",

    # Name of the module to reset
    [Parameter(ParameterSetName = "Name")]
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Name
) {
    switch ($PSCmdlet.ParameterSetName) {
        "Path" { 
            Get-ChildItem -Path $Path | Import-Module -Force
        }
        "Name" {
            Import-Module -Name $Name -Force
        }
    }
}
