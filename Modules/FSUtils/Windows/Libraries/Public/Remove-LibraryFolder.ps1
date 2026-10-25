<#
.SYNOPSIS
    Remove a folder from a Windows library
.DESCRIPTION
    Removes the specified folder from the library
.EXAMPLE
    Remove-LibraryFolder -Name "Documents" -Path "C:\MyDocs"
    # Removes the folder from the library
.EXAMPLE
    Get-ChildItem | Remove-LibraryFolder -Name "Documents"
    # Removes all items from the pipeline from the library
#>
function Remove-LibraryFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string] $Path
    )

    process {

        $library = Resolve-LibraryPath $Name

        # Turns a relative path into a full path without checking if it exists
        # We need to do this incase the folder has already been deleted but the library still tracks the path
        # Trying to resolve a path that does not exist will fail with Resolve-Path; hence this
        $resolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

        if ($PSCmdlet.ShouldProcess($Name, "Remove '$resolvedPath'")) {
            [FSUtils.WindowsLibraries.ShellLibraryInterop]::RemoveFolder($library, $resolvedPath)
        }

    }

}
