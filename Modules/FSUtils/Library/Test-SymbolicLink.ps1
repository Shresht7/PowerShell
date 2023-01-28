<#
.SYNOPSIS
    Test if the given path is a symbolic link
.DESCRIPTION
    Test if the given path is a symbolic link.
.EXAMPLE
    Test-SymbolicLink -Path "./.config"
    Returns True if the path is a symbolic link
#>
function Test-SymbolicLink(
    [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Path', 'Source')]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Item
) {
    # Test if the item is a symbolic link
    $itemInfo = Get-Item -Path $Item
    if ($itemInfo.LinkType -eq "SymbolicLink") {
        return $true
    }
    return $false
}
