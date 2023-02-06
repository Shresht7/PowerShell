<#
.SYNOPSIS
    Remove the node_modules folder from the given path
.DESCRIPTION
    Remove the node_modules folder from the given path
.EXAMPLE
    Remove-NodeModules
    Interactively select a folder to remove the node_modules folder from
.EXAMPLE
    Remove-NodeModules -Path "C:\Projects\MyProject"
    Remove the node_modules folder from the given directory
.EXAMPLE
    Remove-NodeModules -Path "C:\Projects\MyProject\node_modules"
    Remove the node_modules folder from the given path
#>
function Remove-NodeModules {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    param (
        # The path to the folder containing the node_modules folder to remove.
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript({ Test-Path -Path $_ })]
        [string] $Path = (
            Get-ChildItem -Directory -Path $PWD.Path |
            Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "node_modules") } |
            Invoke-Fzf -Multi -Preview "pwsh -NoProfile -Command Get-Size -Path {}\node_modules" -Header "Select a folder to remove the node_modules folder from"
        )
    )

    begin {}

    process {
        # If the path is not node_modules
        if (-Not (Split-Path -Path $Path -Leaf) -eq "node_modules") {
            # Get the path to the node_modules folder
            $NodeModulesPath = Join-Path -Path $Path -ChildPath "node_modules"
        }
        else {
            # Set the path to the node_modules folder
            $NodeModulesPath = $Path
        }
        
        # Remove the node_modules folder
        if (Test-Path -Path $NodeModulesPath) {
            if ($PSCmdlet.ShouldProcess($NodeModulesPath, "Remove node_modules folder")) {
                Remove-Item -Path $NodeModulesPath -Recurse -Force
            }
        }
    }

    end {}

}
