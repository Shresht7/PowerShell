<#
.SYNOPSIS
    Link the module to the first `$PSModulePath`
.DESCRIPTION
    Creates a symbolic link for the module in the `$PSModulePath` (usually `$HOME\Documents\PowerShell\Modules`)
.EXAMPLE
    Connect-Module -Path "MyModule.psm1"
    Links the MyModule path to the `$PSModulePath`
#>
function Connect-Module(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Source", "SourcePath", "From")]
    [string] $Path,

    [Alias("DestinationPath", "Target", "TargetPath", "To")]
    [string] $Destination = $Env:PSModulePath.Split(";")[0]
) {
    # Creating symbolic links requires elevated permissions
    if (-not (Test-IsElevated)) {
        Write-Error "Not in Administrator Mode! Elevated permissions are required to create Symbolic-Links"
        return
    }
   
    # Create Symbolic Links
    $Module = Get-Item -Path $Path
    New-Item -ItemType SymbolicLink -Path "$Destination\$($Module.BaseName)" -Target $Module.DirectoryName -Force
}

Export-ModuleMember -Function Connect-Module
