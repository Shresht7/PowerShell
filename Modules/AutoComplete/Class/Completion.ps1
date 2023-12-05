# Namespaces
using namespace System.Management.Automation

# ----------------
# COMPLETION CLASS
# ----------------

# TODO: Support Aliases

# This class represents a completion object. It is used to build a tree of completions.
class Completion {
    # Properties
    [string] $Name # The name of the command
    [string] $Tooltip # The tooltip to display when the command is selected
    [CompletionResultType] $Type = [CompletionResultType]::ParameterValue # The type of completion
    [Completion[]] $Completions # The next set of completions
    [scriptblock] $CompletionsScriptBlock # The script block to execute to generate the next set of completions

    # Constructor
    Completion(
        # The name of the command
        [string] $Name,

        # The tooltip to display when the command is selected
        [string] $Tooltip,
        
        # The next set of completions
        [Completion[]] $Completions,
        
        # The script block to execute to generate the next set of completions.
        # These completions will be added to the $Completions array.
        [scriptblock] $CompletionsScriptBlock
    ) {
        $this.Name = $Name
        $this.Tooltip = $Tooltip
        $this.Completions = $Completions
        $this.CompletionsScriptBlock = $CompletionsScriptBlock
    }
}

# -----------
# CONSTRUCTOR
# -----------

<#
.SYNOPSIS
    Instantiate a new Completion object
.DESCRIPTION
    Instantiate a new Completion object
.EXAMPLE
    New-Completion -Name 'install' -Tooltip 'Install a package' -Completions @(
        New-Completion -Name '-g' -Tooltip 'Save as a global dependency'
        New-Completion -Name '--global' -Tooltip 'Save as a global dependency'
        New-Completion -Name '--save-dev' -Tooltip 'Save as dev-dependency'
    )
.EXAMPLE
    New-Completion -Name "uninstall" -Tooltip "Uninstall a package"
#>
function New-Completion(
    # The name of the command
    [Parameter(Mandatory = $True, Position = 0)]
    [Alias('Command', 'CommandName')]
    [string] $Name,

    # The tooltip to display when the command is selected
    [Parameter(Position = 1)]
    [Alias('Description', 'Help', 'HelpText', 'HelpMessage', 'Message')]
    [string] $Tooltip,

    # The next set of completions
    [Parameter(Position = 2)]
    [Alias('Next', 'NextCompletions', 'SubCompletions')]
    [Completion[]] $Completions,

    # The script block to execute to get the next set of completions.
    # These completions will be added to the $Completions array.
    [Parameter(Position = 3)]
    [Alias('Script')]
    [scriptblock] $ScriptBlock
) {

    # If no tooltip was passed in, use the name
    if (($null -eq $Tooltip) -or ($Tooltip -eq "")) { $Tooltip = $Name }

    # If no next completions are provided, use an empty array
    if (($null -eq $Completions) -or ($Completions.Length -eq 0)) { $Completions = @() }

    # If no script block is provided, use $null
    if ($null -eq $ScriptBlock) { $ScriptBlock = $null }

    # Return the new Completion object
    return [Completion]::new($Name, $Tooltip, $Completions, $ScriptBlock)
}
