<#
.SYNOPSIS
    Gets the broken links
.DESCRIPTION
    Gets the broken links (that do not point to a valid location) in the given directory.
.PARAMETER Path
    The path to search for broken symlinks. If not specified, the current directory is used.
.PARAMETER Recurse
    Specifies whether to search for broken symlinks recursively within subdirectories. By default, only the specified path is searched.
.EXAMPLE
    Get-BrokenSymlinks
    Returns a list of broken symlinks
.EXAMPLE
    Get-BrokenSymlinks | Remove-Item -Confirm
    Removes all broken symlinks asking as you go
#>
function Get-BrokenSymlink(
    # The path to search for broken symlinks. If not specified, the current directory is used.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path $_ -PathType 'Container' })]
    [string]$Path = ".",

    # Specifies whether to search for broken symlinks recursively within subdirectories. By default, only the specified path is searched.
    [switch]$Recurse
) {
    # Recursively get all children and filter out links. Then filter the links again to those who do not have a valid link target
    Get-ChildItem -Path $Path -Recurse:$Recurse | Where-Object { $null -ne $_.LinkTarget -And -Not (Test-Path -Path $_.LinkTarget) }
}
