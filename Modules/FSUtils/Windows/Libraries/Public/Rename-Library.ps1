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

        if ((Test-DefaultLibrary $Name) -or (Test-DefaultLibrary $NewName)) {
            Write-Error "Cannot rename to or from a default library."
            return
        }

        $source = Resolve-LibraryPath $Name
        $targetName = "$NewName.library-ms"

        if (Test-Path -LiteralPath (Join-Path (Split-Path $source) $targetName)) {
            Write-Error "A library named '$NewName' already exists."
            return
        }

        if ($PSCmdlet.ShouldProcess($Name, "Rename library to '$NewName'")) {
            Rename-Item -LiteralPath $source -NewName $targetName
        }
        
    }
}
