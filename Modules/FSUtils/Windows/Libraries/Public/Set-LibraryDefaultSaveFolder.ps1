<#
.SYNOPSIS
    Set default save folder for a library
.DESCRIPTION
    Sets the default save folder for the library
.EXAMPLE
    Set-LibraryDefaultSaveFolder -Name "Documents" -Path "C:\MyDocs"
    # Sets the default save folder
#>
function Set-LibraryDefaultSaveFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name,

        [Parameter(Mandatory)]
        [Alias('Folder')]
        [string] $Path
    )

    $library = Resolve-LibraryPath $Name
    $resolvedPath = (Resolve-Path -LiteralPath $Path).ProviderPath
    if ($PSCmdlet.ShouldProcess($Name, "Set default save folder to '$resolvedPath'")) {
        [PSFSUtils.WindowsLibraries.ShellLibraryInterop]::SetDefaultSaveFolder($library, $resolvedPath)
    }

}
