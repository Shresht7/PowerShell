<#
.SYNOPSIS
    Get help for a topic interactively
.DESCRIPTION
    Get help for a topic interactively.
    The help is displayed in a preview window.
.EXAMPLE
    Get-InteractiveHelp
.EXAMPLE
    Get-InteractiveHelp -Name Get-ChildItem
#>
function Get-InteractiveHelp(
    # Name of the topic
    [Parameter(Mandatory)]
    [Alias('Name')]
    [string] $Topic
) {
    $Help = help $Topic
    $Help | Invoke-Fzf -Preview "pwsh -NoProfile -Command Get-Help {} -Full"
}

Export-ModuleMember -Function Get-InteractiveHelp
