<#
.SYNOPSIS
    Link the module to the first `$PSModulePath`
.DESCRIPTION
    Creates a symbolic link for the module in the `$PSModulePath` (usually `$HOME\Documents\PowerShell\Modules`)
.EXAMPLE
    Connect-Module -Path "MyModule.psm1"
    Links the MyModule path to the `$PSModulePath`
#>
function Connect-Module {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The path to the module to link
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Name", "FullName", "Source", "SourcePath", "From")]
        [string] $Path,

        # The destination path to link the module to (usually `$HOME\Documents\PowerShell\Modules`).
        [Alias("DestinationPath", "Target", "TargetPath", "To")]
        [string] $Destination
    )
    
    # Determine the delimiter based on the operating system
    $Delimiter = if ($IsWindows) { ";" } else { ":" }

    # If no destination is provided, use the first path in `$PSModulePath`
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        $Destination = $Env:PSModulePath.Split($Delimiter)[0]
    }
   
    # Create Symbolic Links
    $Module = Get-Item -Path $Path
    $Destination = Resolve-Path (Join-Path -Path $Destination -ChildPath $Module.BaseName)
    if ($PSCmdlet.ShouldProcess("Linking $($Module.FullName) to $Destination")) {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Module.DirectoryName -Force
    }
}
