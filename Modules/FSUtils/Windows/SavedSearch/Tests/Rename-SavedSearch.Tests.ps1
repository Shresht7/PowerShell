Describe 'Rename-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $savedSearchRoot 'Private'
        $publicRoot = Join-Path $savedSearchRoot 'Public'

        . (Join-Path $privateRoot 'Get-SavedSearchFile.ps1')
        . (Join-Path $privateRoot 'Resolve-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Rename-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        function Get-SavedSearchPath {
            $testSearchPath
        }
    }

    It 'renames a saved search without changing its contents' {
        $source = Join-Path $testSearchPath 'Original.search-ms'
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath $source

        $result = Rename-SavedSearch -Name 'Original' -NewName 'Renamed'

        Test-Path -LiteralPath $source | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $testSearchPath 'Renamed.search-ms') | Should -BeTrue
        $result.Name | Should -Be 'Renamed.search-ms'
        (Get-Content -LiteralPath (Join-Path $testSearchPath 'Renamed.search-ms') -Raw).Trim() | Should -Be '<persistedQuery version="1.0" />'
    }

    It 'supports pipeline input by property name' {
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath (Join-Path $testSearchPath 'Pipeline.search-ms')
        $inputObject = [pscustomobject]@{ Name = 'Pipeline' }

        $inputObject | Rename-SavedSearch -NewName 'Pipeline Renamed' | Out-Null

        Test-Path -LiteralPath (Join-Path $testSearchPath 'Pipeline Renamed.search-ms') | Should -BeTrue
    }

    It 'rejects a new name with the extension' {
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath (Join-Path $testSearchPath 'Extension.search-ms')

        {
            Rename-SavedSearch -Name 'Extension' -NewName 'Renamed.search-ms'
        } | Should -Throw '*base name*'
    }

    It 'rejects an existing destination' {
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath (Join-Path $testSearchPath 'Source.search-ms')
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath (Join-Path $testSearchPath 'Destination.search-ms')

        {
            Rename-SavedSearch -Name 'Source' -NewName 'Destination'
        } | Should -Throw '*already exists*'
    }

    It 'supports WhatIf without renaming' {
        $source = Join-Path $testSearchPath 'Preview.search-ms'
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath $source

        Rename-SavedSearch -Name 'Preview' -NewName 'Preview Renamed' -WhatIf | Should -BeNullOrEmpty

        Test-Path -LiteralPath $source | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $testSearchPath 'Preview Renamed.search-ms') | Should -BeFalse
    }
}
