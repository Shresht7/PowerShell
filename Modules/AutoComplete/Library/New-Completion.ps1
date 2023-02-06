<#
.SYNOPSIS
    Instantiate a new Completion object
.DESCRIPTION
    Instantiate a new Completion object
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

    # The script block to execute to get the next set of completions
    [Parameter(Position = 3)]
    [Alias('Script', 'ScriptBlock')]
    [scriptblock] $CompletionsScript
) {

    # If no tooltip was passed in, use the name
    if (($null -eq $Tooltip) -or ($Tooltip -eq "")) { $Tooltip = $Name }

    # If no next completions are provided, use an empty array
    if (($null -eq $Completions) -or ($Completions.Length -eq 0)) { $Completions = @() }

    # If no script block is provided, use $null
    if ($null -eq $CompletionsScript) { $CompletionsScript = $null }

    # Return the new Completion object
    return [Completion]::new($Name, $Tooltip, $Completions, $CompletionsScript)
}
