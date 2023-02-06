<#
.SYNOPSIS
    Instantiate a new Completion object
.DESCRIPTION
    Instantiate a new Completion object
#>
function New-Completion(
    [string] $Name,
    [string] $Tooltip,
    [Completion[]] $Next,
    [scriptblock] $Script
) {

    # If no tooltip was passed in, use the name
    if (($null -eq $Tooltip) -or ($Tooltip -eq "")) { $Tooltip = $Name }

    # If no next completions are provided, use an empty array
    if (($null -eq $Next) -or ($Next.Length -eq 0)) { $Next = @() }

    # If no script block is provided, use $null
    if ($null -eq $Script) { $Script = $null }

    # Return the new Completion object
    return [Completion]::new($Name, $Tooltip, $Next, $Script)
}
