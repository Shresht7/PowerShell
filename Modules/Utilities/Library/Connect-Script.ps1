<#
.SYNOPSIS
    Link the script to `$HOME\Scripts` folder
.DESCRIPTION
    Creates a symbolic link for the script in the `$HOME\Scripts` folder
.EXAMPLE
    Connect-Script -Path "Get-Library.ps1"
    Links the `Get-Library.ps1` to the `$HOME\Scripts` folder
#>
function Connect-Script(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Source", "SourcePath", "From")]
    [string] $Path,

    [Alias("DestinationPath", "Target", "TargetPath", "To")]
    [string] $Destination = "$HOME\Scripts"
) {
    $Script = Get-Item -Path $Path
    New-Item -ItemType SymbolicLink -Path "$Destination\$($Script.Name)" -Target $Script.FullName -Force
}

Export-ModuleMember -Function Connect-Script
