Describe 'Get-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $savedSearchRoot 'Private'
        $publicRoot = Join-Path $savedSearchRoot 'Public'

        . (Join-Path $privateRoot 'Get-SavedSearchFile.ps1')
        . (Join-Path $privateRoot 'Read-SavedSearchDefinition.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null

        function Get-SavedSearchPath {
            $testSearchPath
        }

        @(
            '<?xml version="1.0" encoding="utf-8"?>'
            '<persistedQuery version="1.0">'
            '  <viewInfo viewMode="details">'
            '    <sortList><sort viewField="System.DateCreated" direction="ascending" /></sortList>'
            '  </viewInfo>'
            '  <query>'
            '    <conditions>'
            '      <condition type="leafCondition" property="System.FileExtension" operator="starts with" propertyType="string" value=".pdf" />'
            '      <condition type="leafCondition" property="System.Size" operator="greater than" propertyType="integer" value="1024" />'
            '    </conditions>'
            '    <kindList><kind name="document" /></kindList>'
            '    <scope><include path="C:\Documents" /><include path="C:\Downloads" /></scope>'
            '  </query>'
            '</persistedQuery>'
        ) | Set-Content -LiteralPath (Join-Path $testSearchPath 'Documents.search-ms')

        '<persistedQuery version="1.0"><query><conditions /></query></persistedQuery>' |
            Set-Content -LiteralPath (Join-Path $testSearchPath 'Empty.search-ms')
    }

    It 'reads the complete saved search definition' {
        $search = Get-SavedSearch -Name 'Documents'

        $search.Name | Should -Be 'Documents'
        $search.Scope | Should -Be @('C:\Documents', 'C:\Downloads')
        $search.Kind | Should -Be 'document'
        $search.Conditions | Should -HaveCount 2
        $search.Conditions[0].Property | Should -Be 'System.FileExtension'
        $search.Conditions[0].Operator | Should -Be 'starts with'
        $search.Conditions[0].PropertyType | Should -Be 'string'
        $search.Conditions[1].Value | Should -Be '1024'
        $search.Sort.Property | Should -Be 'System.DateCreated'
        $search.Sort.Direction | Should -Be 'ascending'
    }

    It 'filters saved searches by name' {
        $searches = @(Get-SavedSearch -Name 'Documents')

        $searches | Should -HaveCount 1
        $searches[0].Name | Should -Be 'Documents'
    }

    It 'reads all saved searches when no name is supplied' {
        @(Get-SavedSearch) | Should -HaveCount 2
    }

    It 'returns an empty condition collection when no conditions exist' {
        $search = Get-SavedSearch -Name 'Empty'

        @($search.Conditions) | Should -HaveCount 0
    }
}
