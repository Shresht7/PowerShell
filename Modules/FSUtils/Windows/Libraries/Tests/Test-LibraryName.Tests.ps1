Describe 'Test-LibraryName' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $librariesRoot 'Private\Test-LibraryName.ps1')
    }

    It 'accepts a valid base name' {
        Test-LibraryName -Name 'Project Files' | Should -Be 'Project Files'
    }

    It 'rejects a whitespace-only name' {
        { Test-LibraryName -Name '  ' } | Should -Throw '*empty or whitespace*'
    }

    It 'rejects the library-ms extension' {
        { Test-LibraryName -Name 'Project Files.library-ms' } | Should -Throw '*base names*'
    }

    It 'rejects invalid filename characters' {
        { Test-LibraryName -Name 'Project:Files' } | Should -Throw '*invalid filename*'
    }
}
