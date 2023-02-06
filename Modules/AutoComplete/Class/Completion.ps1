# Namespaces
using namespace System.Management.Automation

# ----------------
# COMPLETION CLASS
# ----------------

# TODO: Support Aliases

class Completion {
    [string] $Name
    [string] $Tooltip
    [CompletionResultType] $Type = [CompletionResultType]::ParameterValue
    [Completion[]] $Completions
    [scriptblock] $Script

    Completion([string] $Name, [string] $Tooltip, [Completion[]] $Completions, [scriptblock] $Script) {
        $this.Name = $Name
        $this.Tooltip = $Tooltip
        $this.Completions = $Completions
        $this.Script = $Script
    }
}
