<#
.SYNOPSIS
    Determine if a module is installed or not
.DESCRIPTION
    Determine if a module is installed or not.
.EXAMPLE
    Test-Module -Name 'Pester'
.EXAMPLE
    'Pester' | Test-Module
#>
function Test-Module(
    # The name of the module
    [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Module', 'ModuleName')]
    [string] $Name
) {
    $Module = Get-Module -Name $Name -ListAvailable -ErrorAction SilentlyContinue
    if (-not $Module) {
        return $false
    }
    return $true
}
