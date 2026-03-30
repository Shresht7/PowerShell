<#
.SYNOPSIS
    Link the module to the first `$PSModulePath`
.DESCRIPTION
    Creates a symbolic link for the module in the `$PSModulePath` (usually `$HOME\Documents\PowerShell\Modules`)
.EXAMPLE
    Connect-Module -Path "Modules/MyModule/MyModule.psd1"
    Links the MyModule directory to the `$PSModulePath`
.EXAMPLE
    Connect-Module -Path "Modules/MyModule"
    Links the MyModule directory to the `$PSModulePath`
.EXAMPLE
    Get-ChildItem -Path "Modules" -Filter "*.psd1" -Recurse | Connect-Module
    Links all modules found in the Modules folder to the `$PSModulePath`
.NOTES
    This script requires either elevated permissions (administrator-mode) or developer-mode to create symbolic links on Windows.
#>
function Connect-Module {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The path to the module to link (a directory or a .psd1/.psm1 file)
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Name", "FullName", "Source", "SourcePath", "From")]
        [string] $Path,

        # The destination path to link the module to. Defaults to the first path in `$Env:PSModulePath`
        [Alias("DestinationPath", "Target", "TargetPath", "To")]
        [string] $Destination
    )

    process {
        # Determine the delimiter based on the operating system
        $Delimiter = if ($IsWindows) { ";" } else { ":" }

        # If no destination is provided, use the first path in `$PSModulePath`
        if ([string]::IsNullOrWhiteSpace($Destination)) {
            $Destination = $Env:PSModulePath.Split($Delimiter)[0]
        }

        # Ensure the destination path exists
        if (-not (Test-Path $Destination)) {
            Write-Error "Destination path '$Destination' does not exist."
            return
        }

        # Resolve the module path
        $Item = Get-Item -LiteralPath $Path

        # Determine the link name and target directory based on the input type
        if ($Item -is [System.IO.FileInfo]) {
            # If a .psd1 or .psm1 file was provided, use its basename as the module name
            # and its parent directory as the target
            $ModuleName = $Item.BaseName
            $TargetDirectory = $Item.DirectoryName
        }
        elseif ($Item -is [System.IO.DirectoryInfo]) {
            # If a directory was provided, use its name as the module name
            # and the directory itself as the target
            $ModuleName = $Item.Name
            $TargetDirectory = $Item.FullName
        }
        else {
            Write-Error "'$Path' is not a valid file or directory."
            return
        }

        $LinkPath = Join-Path $Destination $ModuleName

        # Check if a symlink already exists at the destination path
        if (Test-Path -LiteralPath $LinkPath) {
            $Existing = Get-Item -LiteralPath $LinkPath -Force

            if ($Existing.LinkType -eq "SymbolicLink") {
                if ($Existing.Target -eq $TargetDirectory) {
                    Write-Verbose "Skipping: $LinkPath already points to correct target"
                    return
                }
                else {
                    Write-Verbose "A symbolic link already exists at '$LinkPath' but points to '$($Existing.Target)' instead of '$TargetDirectory'. Updating the symbolic link to point to the correct target."
                    if ($PSCmdlet.ShouldProcess($LinkPath, "Update Symbolic Link")) {
                        Remove-Item -LiteralPath $LinkPath -Force
                        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetDirectory
                    }
                }
            }
            else {
                Write-Warning "A non-symbolic item already exists at '$LinkPath'. Skipping the creation of the symbolic link for module '$ModuleName' to avoid conflicts."
                return
            }
        }
        else {
            # Create the symbolic link if it doesn't exist
            if ($PSCmdlet.ShouldProcess($LinkPath, "Create Symbolic Link")) {
                New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetDirectory
            }
        }
    }
}
