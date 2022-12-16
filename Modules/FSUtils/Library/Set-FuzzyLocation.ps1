# -----------------
# Set-FuzzyLocation
# -----------------

<#
.SYNOPSIS
    Set the current location to a directory selected by fzf.
.DESCRIPTION
    Set the current location to a directory selected by fzf.
.EXAMPLE
    Set-FuzzyLocation
.EXAMPLE
    Set-FuzzyLocation -Path Module
#>
function Set-FuzzyLocation(
    # The path to set as the initial query for fzf
    [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName', 'Name')]
    [string] $Path
) {
    # Set Fzf Options
    $FzfOptions = @{
        Query   = $Path
        Preview = "pwsh -NoProfile -Command Get-ChildItem -Path {}"
    }

    # Set the current location to the selected directory
    Get-ChildItem -Directory
    | Invoke-Fzf @FzfOptions 
    | Set-Location
}

Set-Alias cdf Set-FuzzyLocation
