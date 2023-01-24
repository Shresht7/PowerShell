<#
.SYNOPSIS
    Get help for a command interactively
.DESCRIPTION
    Get help for a command interactively.
    If no module name is specified, fzf is used to select a module.
    The help is displayed in a preview window.
.EXAMPLE    
    Get-CommandHelp
.EXAMPLE
    Get-CommandHelp -Name PSReadLine
#>
function Get-CommandHelp(
    # Name of the module
    [Alias('Module', 'ModuleName')]
    [string] $Name
) {
    # If the module name is specified, get the module; otherwise use fzf to select a module
    $Module = if ($PSBoundParameters["Name"]) {
        Get-Module -Name $Name
    }
    else {
        Get-Module -ListAvailable | Invoke-Fzf
    }

    # Get the commands of the module and use fzf to select a command to get help for
    Get-Command -Module $Module | Invoke-Fzf -Preview "pwsh -NoProfile -Command Get-Help {} -Full"
}

Export-ModuleMember -Function Get-CommandHelp
