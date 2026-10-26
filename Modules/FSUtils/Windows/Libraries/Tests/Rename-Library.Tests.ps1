Describe 'Rename-Library' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $librariesRoot 'Private\Test-LibraryName.ps1')
        . (Join-Path $librariesRoot 'Public\Rename-Library.ps1')

        $libraryPath = Join-Path $TestDrive 'Original.library-ms'
        Set-Content -LiteralPath $libraryPath -Value 'library definition'

        function Resolve-LibraryPath { param([string] $Name) $libraryPath }
        function Test-DefaultLibrary { param([string] $Name) $false }

        Mock Resolve-LibraryPath { $libraryPath }
        Mock Test-DefaultLibrary { $false }
    }

    It 'renames the library and returns the renamed file' {
        $result = Rename-Library -Name 'Original' -NewName 'Renamed'

        Test-Path -LiteralPath $libraryPath | Should -BeFalse
        $result.Name | Should -Be 'Renamed.library-ms'
        Get-Content -LiteralPath (Join-Path $TestDrive 'Renamed.library-ms') | Should -Be 'library definition'
    }

    It 'resolves the source before checking default-library status' {
        Mock Resolve-LibraryPath { throw 'source not found' }

        { Rename-Library -Name 'Missing' -NewName 'Renamed' } | Should -Throw 'source not found'
        Should -Invoke Resolve-LibraryPath -Exactly 1
    }

    It 'supports WhatIf without renaming' {
        $source = Join-Path $TestDrive 'Preview.library-ms'
        Set-Content -LiteralPath $source -Value 'library definition'
        Mock Resolve-LibraryPath { $source }

        Rename-Library -Name 'Preview' -NewName 'Preview Renamed' -WhatIf

        Test-Path -LiteralPath $source | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $TestDrive 'Preview Renamed.library-ms') | Should -BeFalse
    }
}
