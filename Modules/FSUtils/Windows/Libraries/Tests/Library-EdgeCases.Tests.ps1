Describe 'Set-LibraryDefaultSaveFolder edge cases' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        $publicRoot = Join-Path $librariesRoot 'Public'
        . (Join-Path $publicRoot 'Set-LibraryDefaultSaveFolder.ps1')

        $libraryFile = Join-Path $TestDrive 'Project.library-ms'
        New-Item -ItemType File -Path $libraryFile | Out-Null

        function Resolve-LibraryPath { $libraryFile }
    }

    It 'rejects a missing default folder path' {
        {
            Set-LibraryDefaultSaveFolder -Name 'Project' -Path (Join-Path $TestDrive 'Missing') -ErrorAction Stop
        } | Should -Throw
    }

    It 'supports WhatIf without invoking the interop operation' {
        $folder = Join-Path $TestDrive 'Folder'
        New-Item -ItemType Directory -Path $folder | Out-Null

        Set-LibraryDefaultSaveFolder -Name 'Project' -Path $folder -WhatIf

        Test-Path -LiteralPath $folder -PathType Container | Should -BeTrue
    }
}

Describe 'Remove-Library edge cases' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $librariesRoot 'Private'
        $publicRoot = Join-Path $librariesRoot 'Public'
        . (Join-Path $privateRoot 'Test-DefaultLibrary.ps1')
        . (Join-Path $publicRoot 'Remove-Library.ps1')

        $libraryFile = Join-Path $TestDrive 'Project.library-ms'
        New-Item -ItemType File -Path $libraryFile | Out-Null

        function Resolve-LibraryPath { $libraryFile }
    }

    It 'does not remove a library during WhatIf' {
        Mock Test-DefaultLibrary { $false }

        Remove-Library -Name 'Project' -WhatIf

        Test-Path -LiteralPath $libraryFile | Should -BeTrue
    }

    It 'rejects removal of a default library before ShouldProcess' {
        Mock Resolve-LibraryPath { Join-Path $TestDrive 'Documents.library-ms' }
        Mock Test-DefaultLibrary { $true }

        {
            Remove-Library -Name 'Documents' -WhatIf -ErrorAction Stop
        } | Should -Throw '*Cannot remove default library*'

        Should -Invoke Test-DefaultLibrary -Exactly 1
    }
}

Describe 'Test-DefaultLibrary' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $librariesRoot 'Private\Test-DefaultLibrary.ps1')
    }

    It 'recognizes default library base names and file names' {
        Test-DefaultLibrary -Name 'Documents' | Should -BeTrue
        Test-DefaultLibrary -Name 'Documents.library-ms' | Should -BeTrue
    }

    It 'does not classify custom libraries as default' {
        Test-DefaultLibrary -Name 'Project Files' | Should -BeFalse
    }
}
