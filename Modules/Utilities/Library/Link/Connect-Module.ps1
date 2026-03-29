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
    # The path to the module to link
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Source", "SourcePath", "From")]
    [string] $Path,

    # The destination path to link the module to (usually `$HOME\Documents\PowerShell\Modules`).
    [Alias("DestinationPath", "Target", "TargetPath", "To")]
    [string] $Destination
) {
    # Creating symbolic links requires elevated permissions
    if (-not (Test-IsElevated)) {
        Write-Error "Not in Administrator Mode! Elevated permissions are required to create Symbolic-Links"
        return
    }

    # If no destination is provided, use the first path in `$PSModulePath`
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        if ($PSVersionTable.OS -like "*Windows*") {
            $Destination = $Env:PSModulePath.Split(";")[0]
        }
        else {
            $Destination = $Env:PSModulePath.Split(":")[0] 
        }
    }
   
    # Create Symbolic Links
    $Module = Get-Item -Path $Path
    New-Item -ItemType SymbolicLink -Path "$Destination\$($Module.BaseName)" -Target $Module.DirectoryName -Force
}

Export-ModuleMember -Function Connect-Module
