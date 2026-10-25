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
        [string] $Path
    )

    process {

        $library = Resolve-LibraryPath $Name
        $resolvedPath = (Resolve-Path -LiteralPath $Path).ProviderPath

        if ($PSCmdlet.ShouldProcess($Name, "Remove '$resolvedPath'")) {
            [FSUtils.WindowsLibraries.ShellLibraryInterop]::RemoveFolder($library, $resolvedPath)
        }

    }

}
