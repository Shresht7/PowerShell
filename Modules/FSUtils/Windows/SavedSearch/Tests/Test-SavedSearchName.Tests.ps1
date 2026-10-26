Describe 'Test-SavedSearchName' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $savedSearchRoot 'Private\Test-SavedSearchName.ps1')
    }

    It 'accepts a valid base name' {
        Test-SavedSearchName -Name 'PDF Documents' | Should -Be 'PDF Documents'
    }

    It 'rejects a whitespace-only name' {
        { Test-SavedSearchName -Name '  ' } | Should -Throw '*empty or whitespace*'
    }

    It 'rejects the search-ms extension' {
        { Test-SavedSearchName -Name 'Documents.search-ms' } | Should -Throw '*base names*'
    }

    It 'rejects invalid filename characters' {
        { Test-SavedSearchName -Name 'Documents:PDFs' } | Should -Throw '*invalid filename*'
    }
}
