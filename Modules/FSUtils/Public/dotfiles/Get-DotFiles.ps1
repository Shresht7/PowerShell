<#
.SYNOPSIS
    Gets dot files in a directory
.DESCRIPTION
    Returns all dot files in the given directory, optionally recursing into subfolders
.EXAMPLE
    Get-DotFiles
    Gets dot files in the current folder
.EXAMPLE
    Get-DotFiles -Recurse
    Gets dot files in the current folder and all subfolders
.EXAMPLE
    Get-DotFiles -Path C:\Users -Recurse -Depth 2
    Gets dot files in C:\Users recursing to a depth of 2
.EXAMPLE
    Get-DotFiles -Hidden
    Gets only hidden dot files
.EXAMPLE
    Get-DotFiles -Shown
    Gets only visible dot files
#>
function Get-DotFiles {

    [CmdletBinding()]
    param(
        # Path to search for dot files
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string] $Path = (Get-Location),

        # Recurse into subfolders
        [switch] $Recurse,

        # Max depth for recursion
        [uint] $Depth = 0,

        # Show only hidden dotfiles
        [switch] $Hidden,

        # Show only visible dotfiles
        [Alias('Visible')]
        [switch] $Shown
    )

    # A process block runs once per piped item; without it, only the last item would be handled
    process {
        # Set depth if recursing, default to max if not specified
        $MaxDepth = if ($Recurse -and $Depth -eq 0) { [uint]::MaxValue } else { $Depth }

        # Get all dotfiles (starting with .) under the specified path; recursing if requested
        $dotFiles = Get-ChildItem -Path $Path -Filter '.*' -Recurse:$Recurse -Depth:$MaxDepth -Force

        # Filter by hidden/visible if requested
        if ($Hidden) { $dotFiles = $dotFiles.Where({ $_.Attributes -band [System.IO.FileAttributes]::Hidden }) }
        if ($Shown) { $dotFiles = $dotFiles.Where({ -not ($_.Attributes -band [System.IO.FileAttributes]::Hidden) }) }

        # Return the filtered dotfiles
        $dotFiles
    }

}
