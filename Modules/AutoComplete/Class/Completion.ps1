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
