<#
.SYNOPSIS
    Set the current location to a directory selected by Select-Fuzzy.
.DESCRIPTION
    This function sets the current location to a directory selected using Select-Fuzzy (fuzzy finder).
.EXAMPLE
    Set-LocationFuzzy
    Sets the current location to a directory selected using Select-Fuzzy.
.NOTES
    This function requires the Select-Fuzzy module to be installed.
#>
function Set-LocationFuzzy(
    # The path to set as the initial query for Select-Fuzzy. It can be provided as a string or piped from the pipeline.
    [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('InitialQuery')]
    [string] $Query,

    # The path to perform the Select-Fuzzy search in
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path = $PWD.Path
) {
    # Set the current location to the selected directory
    Get-ChildItem -Path $Path -Directory
    | Select-Fuzzy -Query $Query -PreviewScript { Get-ChildItem -Path $_.FullName -ErrorAction SilentlyContinue }
    | Set-Location
}
