Describe 'New-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $publicRoot = Join-Path $savedSearchRoot 'Public'
        . (Join-Path $publicRoot 'New-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        # Override Get-SavedSearchPath to use test path
        function Get-SavedSearchPath {
            $testSearchPath
        }

        . (Join-Path $savedSearchRoot 'Private\Get-SavedSearchFile.ps1')
        . (Join-Path $savedSearchRoot 'Private\Read-SavedSearchDefinition.ps1')
        . (Join-Path $savedSearchRoot 'Private\Test-SavedSearchCondition.ps1')
        . (Join-Path $savedSearchRoot 'Private\New-SavedSearchXml.ps1')
        . (Join-Path $savedSearchRoot 'Private\Write-SavedSearchDefinition.ps1')
        . (Join-Path $savedSearchRoot 'Private\Test-SavedSearchName.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearch.ps1')
    }

    It 'creates a valid persisted query with operator conditions' {
        $file = New-SavedSearch -Name 'PDF Documents' `
            -Scope 'C:\Users\Test\Documents' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }

        $xml = [xml](Get-Content -LiteralPath $file.FullName -Raw)

        $xml.persistedQuery.version | Should -Be '1.0'
        $xml.persistedQuery.query.conditions.condition.type | Should -Be 'leafCondition'
        $xml.persistedQuery.query.conditions.condition.property | Should -Be 'System.FileExtension'
        $xml.persistedQuery.query.conditions.condition.operator | Should -Be 'starts with'
        $xml.persistedQuery.query.conditions.condition.value | Should -Be '.pdf'
        $xml.persistedQuery.query.kindList.kind.name | Should -Be 'item'
        $xml.persistedQuery.query.scope.include.path | Should -Be 'C:\Users\Test\Documents'
    }

    It 'supports multiple conditions and scopes' {
        $file = New-SavedSearch -Name 'Documents' `
            -Scope @('C:\Users\Test\Documents', 'C:\Users\Test\Downloads') `
            -Condition @(
            @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }
            @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1024'; PropertyType = 'integer' }
        )

        $xml = [xml](Get-Content -LiteralPath $file.FullName -Raw)

        @($xml.persistedQuery.query.conditions.condition) | Should -HaveCount 2
        @($xml.persistedQuery.query.scope.include) | Should -HaveCount 2
        $xml.persistedQuery.query.conditions.condition[1].propertyType | Should -Be 'integer'
    }

    It 'preserves property types in generated conditions' {
        $file = New-SavedSearch -Name 'Typed Search' `
            -Scope 'C:\Temp' `
            -Condition @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1024'; PropertyType = 'integer' }

        $xml = [xml](Get-Content -LiteralPath $file.FullName -Raw)
        $condition = $xml.persistedQuery.query.conditions.condition

        $condition.propertyType | Should -Be 'integer'
        $condition.operator | Should -Be 'greater than'
    }

    It 'round-trips property types through Get-SavedSearch' {
        New-SavedSearch -Name 'Round Trip' `
            -Scope @('C:\Temp', 'C:\Windows\Temp') `
            -Condition @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1024'; PropertyType = 'integer' } `
            -Kind 'document' `
            -SortBy 'System.DateCreated' `
            -SortDirection ascending

        $search = Get-SavedSearch -Name 'Round Trip'

        $search.Name | Should -Be 'Round Trip'
        $search.Path | Should -Match 'Round Trip\.search-ms$'
        $search.Scope | Should -Be @('C:\Temp', 'C:\Windows\Temp')
        $search.Kind | Should -Be 'document'
        $search.Conditions.PropertyType | Should -Be 'integer'
        $search.Conditions.Property | Should -Be 'System.Size'
        $search.Conditions.Operator | Should -Be 'greater than'
        $search.Conditions.Value | Should -Be '1024'
        $search.Sort.Property | Should -Be 'System.DateCreated'
        $search.Sort.Direction | Should -Be 'ascending'
    }

    It 'escapes XML attribute values' {
        $file = New-SavedSearch -Name 'Escaped' `
            -Scope 'C:\Users\Test\A&B' `
            -Condition @{ Property = 'System.ItemName'; Operator = 'contains'; Value = 'A&B <test>' }

        $xml = [xml](Get-Content -LiteralPath $file.FullName -Raw)

        $xml.persistedQuery.query.scope.include.path | Should -Be 'C:\Users\Test\A&B'
        $xml.persistedQuery.query.conditions.condition.value | Should -Be 'A&B <test>'
    }

    It 'rejects a condition without an operator' {
        {
            New-SavedSearch -Name 'Invalid' -Scope 'C:\Temp' `
                -Condition @{ Property = 'System.FileExtension'; Value = '.pdf' }
        } | Should -Throw '*non-empty Operator*'
    }

    It 'rejects unsupported property types' {
        {
            New-SavedSearch -Name 'Invalid Type' -Scope 'C:\Temp' `
                -Condition @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1024'; PropertyType = 'currency' }
        } | Should -Throw '*Unsupported PropertyType*'
    }

    It 'defaults a missing property type to string' {
        $file = New-SavedSearch -Name 'Default Type' -Scope 'C:\Temp' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' }

        $xml = [xml](Get-Content -LiteralPath $file.FullName -Raw)

        $xml.persistedQuery.query.conditions.condition.propertyType | Should -Be 'string'
    }

    It 'rejects blank scope entries' {
        {
            New-SavedSearch -Name 'Invalid Scope' -Scope @('C:\Temp', ' ') `
                -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' }
        } | Should -Throw '*Scope entries cannot be empty*'
    }

    It 'does not overwrite an existing search without Force' {
        New-SavedSearch -Name 'Existing' -Scope 'C:\Temp' `
            -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.txt' }

        {
            New-SavedSearch -Name 'Existing' -Scope 'C:\Temp' `
                -Condition @{ Property = 'System.FileExtension'; Operator = 'equals'; Value = '.pdf' }
        } | Should -Throw '*already exists*'
    }
}
