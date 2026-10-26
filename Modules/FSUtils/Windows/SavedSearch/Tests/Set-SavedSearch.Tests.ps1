Describe 'Set-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $savedSearchRoot 'Private'
        $publicRoot = Join-Path $savedSearchRoot 'Public'

        . (Join-Path $privateRoot 'Get-SavedSearchFile.ps1')
        . (Join-Path $privateRoot 'Read-SavedSearchDefinition.ps1')
        . (Join-Path $privateRoot 'Resolve-SavedSearchPath.ps1')
        . (Join-Path $privateRoot 'Test-SavedSearchCondition.ps1')
        . (Join-Path $privateRoot 'New-SavedSearchXml.ps1')
        . (Join-Path $privateRoot 'Test-SavedSearchName.ps1')
        . (Join-Path $privateRoot 'Write-SavedSearchDefinition.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'New-SavedSearch.ps1')
        . (Join-Path $publicRoot 'Set-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        function Get-SavedSearchPath {
            $testSearchPath
        }
    }

    It 'updates only the supplied properties' {
        New-SavedSearch -Name 'Editable' `
            -Scope 'C:\Documents' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' } `
            -Kind 'document' `
            -SortBy 'System.DateModified' `
            -SortDirection descending

        Set-SavedSearch -Name 'Editable' -SortDirection ascending | Should -Not -BeNullOrEmpty

        $xml = [xml](Get-Content -LiteralPath (Join-Path $testSearchPath 'Editable.search-ms') -Raw)
        $xml.persistedQuery.query.scope.include.path | Should -Be 'C:\Documents'
        $xml.persistedQuery.query.kindList.kind.name | Should -Be 'document'
        $xml.persistedQuery.query.conditions.condition.value | Should -Be '.pdf'
        $xml.persistedQuery.viewInfo.sortList.sort.viewField | Should -Be 'System.DateModified'
        $xml.persistedQuery.viewInfo.sortList.sort.direction | Should -Be 'ascending'
    }

    It 'replaces conditions and scopes' {
        New-SavedSearch -Name 'Replaceable' `
            -Scope 'C:\Old' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' }

        Set-SavedSearch -Name 'Replaceable' `
            -Scope @('C:\New', 'C:\Other') `
            -Condition @(
                @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1024'; PropertyType = 'integer' }
                @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.pdf' }
            ) | Out-Null

        $xml = [xml](Get-Content -LiteralPath (Join-Path $testSearchPath 'Replaceable.search-ms') -Raw)
        @($xml.persistedQuery.query.scope.include) | Should -HaveCount 2
        @($xml.persistedQuery.query.conditions.condition) | Should -HaveCount 2
        $xml.persistedQuery.query.conditions.condition[0].propertyType | Should -Be 'integer'
    }

    It 'allows conditions to be cleared' {
        New-SavedSearch -Name 'Clear Conditions' `
            -Scope 'C:\Temp' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' } | Out-Null

        Set-SavedSearch -Name 'Clear Conditions' -Condition @() | Out-Null

        $xml = [xml](Get-Content -LiteralPath (Join-Path $testSearchPath 'Clear Conditions.search-ms') -Raw)
        $xml.SelectNodes('/persistedQuery/query/conditions/condition').Count | Should -Be 0
    }

    It 'supports WhatIf without changing the file' {
        New-SavedSearch -Name 'Preview' `
            -Scope 'C:\Original' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' } | Out-Null

        $path = Join-Path $testSearchPath 'Preview.search-ms'
        $before = Get-Content -LiteralPath $path -Raw

        Set-SavedSearch -Name 'Preview' -SortDirection ascending -WhatIf | Should -BeNullOrEmpty

        (Get-Content -LiteralPath $path -Raw) | Should -Be $before
    }

    It 'requires at least one update property' {
        New-SavedSearch -Name 'No Changes' `
            -Scope 'C:\Temp' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' } | Out-Null

        { Set-SavedSearch -Name 'No Changes' } | Should -Throw '*at least one property*'
    }
}
