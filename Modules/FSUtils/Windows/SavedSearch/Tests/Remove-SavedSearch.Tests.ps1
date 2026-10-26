Describe 'Remove-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $savedSearchRoot 'Private'
        $publicRoot = Join-Path $savedSearchRoot 'Public'

        . (Join-Path $privateRoot 'Get-SavedSearchFile.ps1')
        . (Join-Path $privateRoot 'Resolve-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Remove-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        function Get-SavedSearchPath {
            $testSearchPath
        }
    }

    It 'removes an existing saved search' {
        $path = Join-Path $testSearchPath 'Remove Me.search-ms'
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath $path

        Remove-SavedSearch -Name 'Remove Me' -Confirm:$false

        Test-Path -LiteralPath $path | Should -BeFalse
    }

    It 'supports WhatIf without removing the file' {
        $path = Join-Path $testSearchPath 'Keep Me.search-ms'
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath $path

        Remove-SavedSearch -Name 'Keep Me' -WhatIf

        Test-Path -LiteralPath $path | Should -BeTrue
    }

    It 'accepts pipeline input by property name' {
        $path = Join-Path $testSearchPath 'Pipeline.search-ms'
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath $path

        [pscustomobject]@{ Name = 'Pipeline' } |
            Remove-SavedSearch -Confirm:$false

        Test-Path -LiteralPath $path | Should -BeFalse
    }

    It 'throws when the saved search does not exist' {
        {
            Remove-SavedSearch -Name 'Missing' -Confirm:$false
        } | Should -Throw "*Saved search 'Missing' not found*"
    }
}
