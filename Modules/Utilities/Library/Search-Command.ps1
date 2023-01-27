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
        $FzfOptions = @{
            Prompt        = "Command: "
            Header        = "Select a command"
            Preview       = "pwsh -NoProfile -Command Get-Help {} -Full"
            PreviewWindow = "right:70%"
            Height        = "100%"
        }
        return Get-Command -Name *$Name*
        | Sort-Object -Property Name
        | Invoke-Fzf @FzfOptions
    }

    # If the module name is specified, get the module; otherwise use fzf to select a module
    $Module = if ($PSBoundParameters["Module"]) {
        Get-Module -Name *$Module*
    }
    else {
        $FzfOptions = @{
            Prompt        = "Module: "
            Header        = "Select a module"
            Preview       = "pwsh -NoProfile -Command Get-Command -Module {}"
            PreviewWindow = "right:70%"
            Height        = "100%"
        }
        Get-Module -ListAvailable | Sort-Object -Property Name | Invoke-Fzf @FzfOptions
    }

    # Exit if no module was selected
    if (-not $Module) {
        return
    }

    # Make sure the module has been imported
    Import-Module -Name $Module

    # Get the commands of the module and use fzf to select a command to get help for
    $FzfOptions = @{
        Prompt        = "Command: "
        Header        = "Select a command"
        Preview       = "pwsh -NoProfile -Command Get-Help {} -Full"
        PreviewWindow = "right:70%"
        Height        = "100%"
    }
    $Command = Get-Command -Module $Module
    | Sort-Object -Property Name
    | Invoke-Fzf @FzfOptions

    # Exit if no command was selected
    if (-not $Command) {
        return
    }

    # Return the command
    return $Command
}

Export-ModuleMember -Function Search-Command
