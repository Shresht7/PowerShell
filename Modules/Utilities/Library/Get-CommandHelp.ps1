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
        Get-Module -ListAvailable
        | Sort-Object -Property Name
        | Invoke-Fzf -Preview "pwsh -NoProfile -Command Get-Command -Module {}" -Height "100%"
    }

    # Exit if no module was selected
    if (-not $Module) {
        return
    }

    # Get the commands of the module and use fzf to select a command to get help for
    $Command = Get-Command -Module $Module
    | Sort-Object -Property Name
    | Invoke-Fzf -Preview "pwsh -NoProfile -Command Get-Help {} -Full" -Height "100%" -PreviewWindow "right:70%"

    # Exit if no command was selected
    if (-not $Command) {
        return
    }

    # Get help for the command
    Get-Help $Command -Full
}

Export-ModuleMember -Function Get-CommandHelp
