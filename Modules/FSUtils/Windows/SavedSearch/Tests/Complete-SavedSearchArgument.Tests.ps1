Describe 'Complete-SavedSearchArgument' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $savedSearchRoot 'Private\Complete-SavedSearchArgument.ps1')
    }

    It 'completes saved search kinds' {
        $results = @(Complete-SavedSearchArgument -ParameterName Kind -WordToComplete '')

        $results.CompletionText | Should -Contain 'item'
        $results.CompletionText | Should -Contain 'document'
        $results.CompletionText | Should -Contain 'folder'
    }

    It 'completes sort directions' {
        $results = @(Complete-SavedSearchArgument -ParameterName SortDirection -WordToComplete '')

        $results.CompletionText | Should -Be @('ascending', 'descending')
    }

    It 'completes common sort properties' {
        $results = @(Complete-SavedSearchArgument -ParameterName SortBy -WordToComplete 'System.Date')

        $results.CompletionText | Should -Be @(
            'System.DateModified'
            'System.DateCreated'
        )
    }

    It 'completes condition templates' {
        $results = @(Complete-SavedSearchArgument -ParameterName Condition -WordToComplete '')

        $results | Should -HaveCount 5
        $results.CompletionText | Should -Contain "@{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }"
        $results.CompletionText | Should -Contain "@{ Property = 'System.Size'; Operator = 'greater than'; Value = ''; PropertyType = 'integer' }"
    }

    It 'filters completions by prefix' {
        $results = @(Complete-SavedSearchArgument -ParameterName Kind -WordToComplete 'doc')

        $results.CompletionText | Should -Be 'document'
    }

    It 'returns descriptions for completions' {
        $result = Complete-SavedSearchArgument -ParameterName SortDirection -WordToComplete 'asc'

        $result.ListItemText | Should -Be 'ascending'
        $result.ToolTip | Should -Be 'Sort from lowest to highest'
    }
}
