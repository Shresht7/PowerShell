<#
.SYNOPSIS
    Hides a file or directory
.DESCRIPTION
    Hides the specified item on the filesystem by setting its hidden attribute
.EXAMPLE
    Hide-Item "file.txt"
    Hides the specified file
.EXAMPLE
    Hide-Item -Path "file.txt"
    Hides the file specified by the path
.EXAMPLE
    Hide-Item -Item (Get-Item "file.txt")
    Hides the file specified by the item
.EXAMPLE
    Hide-Item -Path "dir" -WhatIf
    Shows what would be hidden without actually hiding it
.EXAMPLE
    Get-ChildItem | Hide-Item -Confirm
    Hides all items in the current directory with confirmation
#>
function Hide-Item {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Item")]
    param(
        # The file or directory to hide
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "Item", Position = 0)]
        [System.IO.FileSystemInfo] $Item,

        # The path to the item to hide
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "Path", Position = 0)]
        [SupportsWildcards()]
        [Alias("FullName")]
        [string] $Path
    )


    process {
        # Get item if only path is given
        if (-not $Item -and $Path) {
            $Item = Get-Item $Path
        }
        
        if ($PSCmdlet.ShouldProcess($Item)) {
            if ($IsWindows) {
                if ($Item.Attributes -band [System.IO.FileAttributes]::Hidden) { return }       # Skip if already hidden
                $Item.Attributes = $Item.Attributes -bor [System.IO.FileAttributes]::Hidden     # Set hidden attribute bit
            }
            else {
                # TODO: Implement hide for Linux
            }
        }
    }

}
