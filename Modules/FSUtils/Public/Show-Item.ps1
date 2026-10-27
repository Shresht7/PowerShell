<#
.SYNOPSIS
    Shows a hidden item
.DESCRIPTION
    Shows a hidden file or directory by clearing the hidden attribute
.EXAMPLE
    Show-Item -Path "file.txt"
    Shows the file if hidden
.EXAMPLE
    Show-Item -Item (Get-Item "dir")
    Shows the directory if hidden
.EXAMPLE
    Show-Item -Path "file.txt" -WhatIf
    Shows what would be unhidden without actually changing it
.EXAMPLE
    Get-ChildItem -Hidden | Show-Item -Confirm
    Shows all hidden items with confirmation
#>
function Show-Item {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Item")]
    param(
        # The file or directory to show
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "Item", Position = 0)]
        [System.IO.FileSystemInfo] $Item,

        # The path to the item to show
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
                if (-not ($Item.Attributes -band [System.IO.FileAttributes]::Hidden)) { return }        # Skip if not hidden
                $Item.Attributes = $Item.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden)    # Remove hidden attribute
            }
            else {
                # TODO: Implement show for Linux
            }
        }
    }
}
