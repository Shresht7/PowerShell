Describe 'New-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $publicRoot = Join-Path $savedSearchRoot 'Public'
        . (Join-Path $publicRoot 'New-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        function Get-SavedSearchPath {
            $testSearchPath
        }
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
        } | Should -Throw '*Property, Operator, and Value*'
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
