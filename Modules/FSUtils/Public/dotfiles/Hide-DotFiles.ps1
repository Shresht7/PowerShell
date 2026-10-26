<#
.SYNOPSIS
    Hides dotfiles
.DESCRIPTION
    Sets the hidden attribute on dotfiles to hide them.
    Works on files passed in or finds them in the current folder.
    Supports ShouldProcess for confirmation (e.g. -WhatIf, -Confirm)
.EXAMPLE
    Hide-DotFiles
    Hides dotfiles in the current folder
.EXAMPLE
    Hide-DotFiles -Recurse
    Hides dotfiles in all subfolders recursively
.EXAMPLE
    Hide-DotFiles -Path .\file.txt
    Hides a specific dotfile
.EXAMPLE
    Get-DotFiles | Hide-DotFiles
    Hides all dotfiles found by Get-DotFiles
.EXAMPLE
    Hide-DotFiles -WhatIf
    Shows what would be hidden without actually hiding it
#>
function Hide-DotFiles {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Path to the file to hide
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("FullName")]
        [string[]] $Path,

        # Recurse into subfolders
        [switch] $Recurse,

        # Depth for recursion
        [uint] $Depth
    )

    process {
        # Explicit/piped paths are used as-is
        $Items = if ($PSBoundParameters.ContainsKey('Path')) {
            Get-Item -LiteralPath $Path -Force
        }
        # otherwise discover dot files in the current folder
        else {
            Get-DotFiles -Path (Get-Location) -Recurse:$Recurse -Depth:$Depth
        }
        
        foreach ($Item in $Items) {

            # Skip if already hidden
            if ($Item.Attributes -band [System.IO.FileAttributes]::Hidden) { continue }

            # Make it hidden
            if ($PSCmdlet.ShouldProcess($Item.FullName, "Set Attribute: Hidden")) {
                Write-Verbose -Message "Hiding $($Item.Name)"
                $Item.Attributes = $Item.Attributes -bor [System.IO.FileAttributes]::Hidden
            }

        }
    }

}
