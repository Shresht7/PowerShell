<#
.SYNOPSIS
    Test if the given path is a symbolic link
.DESCRIPTION
    This function checks if the specified path is a symbolic link.
.EXAMPLE
    Test-IsSymbolicLink -Path "./.config"
    Returns True if the path is a symbolic link
#>
function Test-IsSymbolicLink(
    # The path to test. It can be provided as a string or piped from the pipeline.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('Path', 'Source')]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Item
) {
    # Check if the path actually exists
    if (-not (Test-Path -Path $Item)) {
        throw "The specified path does not exist: $Item"
    }

    # Test if the item is a symbolic link
    return (Get-Item -Path $Item).LinkType -eq "SymbolicLink"
}
