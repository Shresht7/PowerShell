<#
.SYNOPSIS
    Renames a Windows library.
.DESCRIPTION
    Renames a non-default Windows library without changing its contents.
    Library names are base names; do not include the .library-ms extension.
.EXAMPLE
    Rename-Library -Name 'Project Files' -NewName 'Project Documents'
    Renames a library while preserving its definition.
.EXAMPLE
    Get-Library -Name 'Project Files' |
        Rename-Library -NewName 'Project Documents'
    Renames a library received through the pipeline.
.EXAMPLE
    Rename-Library -Name 'Project Files' -NewName 'Project Documents' -WhatIf
    Shows what would happen without renaming the library.
#>
function Rename-Library {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Library', 'LibraryName')]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $NewName
    )

    process {

        Test-LibraryName -Name $Name | Out-Null
        Test-LibraryName -Name $NewName | Out-Null

        $source = Resolve-LibraryPath $Name

        if ((Test-DefaultLibrary ([System.IO.Path]::GetFileNameWithoutExtension($source))) -or
            (Test-DefaultLibrary $NewName)) {
            Write-Error "Cannot rename to or from a default library."
            return
        }

        $targetName = "$NewName.library-ms"

        if (Test-Path -LiteralPath (Join-Path (Split-Path $source) $targetName)) {
            Write-Error "A library named '$NewName' already exists."
            return
        }

        if ($PSCmdlet.ShouldProcess($Name, "Rename library to '$NewName'")) {
            Rename-Item -LiteralPath $source -NewName $targetName
            Get-Item -LiteralPath (Join-Path (Split-Path $source) $targetName)
        }

    }
}
