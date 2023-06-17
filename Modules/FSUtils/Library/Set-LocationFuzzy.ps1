<#
.SYNOPSIS
    Set the current location to a directory selected by fzf.
.DESCRIPTION
    This function sets the current location to a directory selected using fzf (fuzzy finder).
.EXAMPLE
    Set-LocationFuzzy
    Sets the current location to a directory selected using fzf.
#>
function Set-LocationFuzzy(
    # The path to set as the initial query for fzf. It can be provided as a string or piped from the pipeline.
    [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('InitialQuery')]
    [string] $Query,

    # The path to perform the fzf search in
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path = $PWD.Path
) {
    # Set Fzf Options
    $FzfOptions = @{
        Query   = $Query
        Preview = "pwsh -NoProfile -Command Get-ChildItem -Path {}"
    }

    # Set the current location to the selected directory
    Get-ChildItem -Path $Path -Directory
    | Invoke-Fzf @FzfOptions 
    | Set-Location
}
