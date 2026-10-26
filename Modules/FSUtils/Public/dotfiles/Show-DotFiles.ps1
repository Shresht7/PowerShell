<#
.SYNOPSIS
    Shows dotfiles
.DESCRIPTION
    Removes the hidden attribute from dotfiles to make them visible.
    Works on files passed in or found in the current folder.
    Supports ShouldProcess for confirmation (e.g. -WhatIf, -Confirm)
.EXAMPLE
    Show-DotFiles
    Shows dotfiles in the current folder
.EXAMPLE
    Show-DotFiles -Recurse
    Shows dotfiles recursively
.EXAMPLE
    Show-DotFiles -Path .\file.txt
    Shows a specific dotfile
.EXAMPLE
    Get-DotFiles | Show-DotFiles
    Shows all dotfiles found by Get-DotFiles
.EXAMPLE
    Show-DotFiles -WhatIf
    Shows what would be visible without changing it
#>
function Show-DotFiles {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Path to the file to show
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("FullName")]
        [string[]] $Path,

        # Recurse into subfolders
        [switch] $Recurse,

        # Depth for recursion
        [uint] $Depth,

        # Return shown items if set
        [switch] $PassThru
    )

    process {

        # Explicit/piped paths are used as-is
        $Items = if ($PSBoundParameters.ContainsKey('Path')) {
            Get-Item -LiteralPath $Path -Force
        }
        # otherwise find dotfiles in current folder
        else {
            Get-DotFiles -Path (Get-Location) -Recurse:$Recurse -Depth:$Depth
        }

        foreach ($Item in $Items) {

            # Skip if not hidden
            if (-not ($Item.Attributes -band [System.IO.FileAttributes]::Hidden)) { continue }

            # Make it visible
            if ($PSCmdlet.ShouldProcess($Item.FullName, "Show")) {
                Write-Verbose -Message "Showing $($Item.FullName)"
                $Item.Attributes = $Item.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden) # remove only hidden flag
            }

            # Output if requested
            if ($PassThru) { $Item }
        }

    }

}
