<#
.SYNOPSIS
    Link the script to `$HOME\Scripts` folder
.DESCRIPTION
    Creates a symbolic link for the script in the `$HOME\Scripts` folder.
    Since the script is linked to a folder in the PATH environment variable,
    it can be run from anywhere by just typing its name.
.EXAMPLE
    Connect-Script -Path "Get-Library.ps1"
    Links the `Get-Library.ps1` to the `$HOME\Scripts` folder
.EXAMPLE
    Connect-Script -Path "Get-Library.ps1" -Destination "$HOME\Documents\PowerShell\Scripts"
    Links the `Get-Library.ps1` to the `$HOME\Documents\PowerShell\Scripts` folder
.NOTES
    This script requires either elevated permissions (administrator mode) or developer-mode to create symbolic links on Windows.
#>
function Connect-Script {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The path to the script to link. This can be a relative or absolute path
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Name", "FullName", "Source", "SourcePath", "From")]
        [string] $Path,

        # The destination folder for the symbolic link. Defaults to `$HOME\Scripts`
        [Alias("DestinationPath", "Target", "TargetPath", "To")]
        [string] $Destination = "$HOME\Scripts"
    )

    $Script = Get-Item -Path $Path
    $Destination = Resolve-Path (Join-Path -Path $Destination -ChildPath $Script.Name)

    if ($PSCmdlet.ShouldProcess("Linking $($Script.FullName) to $Destination")) {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Script.FullName -Force
    }
}
