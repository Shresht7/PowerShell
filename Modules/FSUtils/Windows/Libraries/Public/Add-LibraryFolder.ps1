<#
.SYNOPSIS
    Add a folder to a Windows library
.DESCRIPTION
    Adds a folder to the specified library
.EXAMPLE
    Add-LibraryFolder -Name "Documents" -Path "C:\MyDocs"
    # Adds the folder to the library
.EXAMPLE
    Get-ChildItem | Add-LibraryFolder -Name "Documents"
    # Adds all items from the pipeline to the library
#>
function Add-LibraryFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(

        # Name of the library to add to
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name,

        # Path to add to the library
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string] $Path
    )

    process {

        $library = Resolve-LibraryPath $Name
        $resolvedPath = (Resolve-Path -LiteralPath $Path).ProviderPath

        if ($PSCmdlet.ShouldProcess($Name, "Add '$resolvedPath'")) {
            [FSUtils.WindowsLibraries.ShellLibraryInterop]::AddFolder($library, $resolvedPath)
        }

    }
}
