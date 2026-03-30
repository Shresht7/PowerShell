<#
.SYNOPSIS
    Link the script to `$HOME\Scripts` folder
.DESCRIPTION
    Creates a symbolic link for the script in the `$HOME\Scripts` folder.
    Since the script is linked to a folder in the PATH environment variable,
    it can be run from anywhere by just typing its name.
.EXAMPLE
    Connect-Script -Path "Get-Library.ps1"
    Links the `Get-Library.ps1` to `$HOME\Scripts`
.EXAMPLE
    Connect-Script -Path "Get-Library.ps1" -Destination "$HOME\Documents\PowerShell\Scripts"
    Links the `Get-Library.ps1` to `$HOME\Documents\PowerShell\Scripts`
.EXAMPLE
    Get-ChildItem -Path "Scripts" -Filter "*.ps1" | Connect-Script
    Links all scripts found in the Scripts folder to `$HOME\Scripts`
.NOTES
    This script requires either elevated permissions (administrator-mode) or developer-mode to create symbolic links on Windows.
#>
function Connect-Script {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The path to the script to link
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Name", "FullName", "Source", "SourcePath", "From")]
        [string] $Path,

        # The destination folder(s) for the symbolic link. Defaults to `$HOME\Scripts`
        [Alias("DestinationPath", "Target", "TargetPath", "To")]
        [string[]] $Destination = "$HOME\Scripts"
    )

    process {
        $Script = Get-Item -LiteralPath $Path

        foreach ($Dest in $Destination) {
            if (-not (Test-Path $Dest)) {
                Write-Warning "Destination path '$Dest' does not exist. Skipping."
                continue
            }

            $LinkPath = Join-Path $Dest $Script.Name

            # Check if a symlink already exists at the destination path
            if (Test-Path -LiteralPath $LinkPath) {
                $Existing = Get-Item -LiteralPath $LinkPath -Force

                if ($Existing.LinkType -eq "SymbolicLink") {
                    if ($Existing.Target -eq $Script.FullName) {
                        Write-Verbose "Skipping: $LinkPath already points to correct target"
                        continue
                    }
                    else {
                        Write-Verbose "A symbolic link already exists at '$LinkPath' but points to '$($Existing.Target)' instead of '$($Script.FullName)'. Updating the symbolic link to point to the correct target."
                        if ($PSCmdlet.ShouldProcess($LinkPath, "Update Symbolic Link")) {
                            Remove-Item -LiteralPath $LinkPath -Force
                            New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Script.FullName
                        }
                    }
                }
                else {
                    Write-Warning "A non-symlink item already exists at '$LinkPath'. Skipping linking for '$($Script.FullName)'."
                    continue
                }
            }
            else {
                # Create the symbolic link if it doesn't exist
                if ($PSCmdlet.ShouldProcess($LinkPath, "Create Symbolic Link")) {
                    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Script.FullName
                }
            }
        }
    }
}
