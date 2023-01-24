<#
.SYNOPSIS
    Search for a command interactively
.DESCRIPTION
    Search for a command interactively.
    The help is displayed in a preview window.
.EXAMPLE    
    Search-Command
    Search for a command interactively
.EXAMPLE
    Search-Command -Name Item
    Search for a command with `Item` in the name
.EXAMPLE
    Search-Command -Module PSReadLine
    Search for a command in the `PSReadLine` module
#>
function Search-Command(
    # Name of the command
    [Alias('Command', 'CommandName')]
    [string] $Name,

    # Name of the module
    [Alias('ModuleName')]
    [string] $Module
) {
    # If a command is specified, show the help
    if ($Name) {
        return Get-Command -Name *$Name*
        | Sort-Object -Property Name
        | Invoke-Fzf -Preview "pwsh -NoProfile -Command Get-Help {} -Full" -PreviewWindow "right:70%" -Height "100%"
    }

    # If the module name is specified, get the module; otherwise use fzf to select a module
    $Module = if ($PSBoundParameters["Module"]) {
        Get-Module -Name *$Module*
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

    # Return the command
    return $Command
}

Export-ModuleMember -Function Search-Command
