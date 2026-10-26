<#
.SYNOPSIS
    Completes New-SavedSearch parameter values.
#>
function Complete-SavedSearchArgument {
    param(
        [Parameter(Mandatory)]
        [string] $ParameterName,

        [string] $WordToComplete
    )

    $Values = switch ($ParameterName) {
        'Kind' {
            @(
                @{ Value = 'item'; Description = 'All indexed items' }
                @{ Value = 'document'; Description = 'Documents' }
                @{ Value = 'folder'; Description = 'Folders' }
                @{ Value = 'picture'; Description = 'Pictures' }
                @{ Value = 'music'; Description = 'Music' }
                @{ Value = 'video'; Description = 'Videos' }
                @{ Value = 'email'; Description = 'Email messages' }
            )
        }
        'SortDirection' {
            @(
                @{ Value = 'ascending'; Description = 'Sort from lowest to highest' }
                @{ Value = 'descending'; Description = 'Sort from highest to lowest' }
            )
        }
        'SortBy' {
            @(
                @{ Value = 'System.DateModified'; Description = 'Date modified' }
                @{ Value = 'System.DateCreated'; Description = 'Date created' }
                @{ Value = 'System.ItemNameDisplay'; Description = 'Display name' }
                @{ Value = 'System.Search.Rank'; Description = 'Search relevance rank' }
                @{ Value = 'System.Size'; Description = 'Size' }
                @{ Value = 'System.ItemTypeText'; Description = 'Item type' }
                @{ Value = 'System.ItemFolderPathDisplay'; Description = 'Folder path' }
            )
        }
        'Condition' {
            @(
                @{ Value = "@{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }"; Description = 'File extension condition' }
                @{ Value = "@{ Property = 'System.FileName'; Operator = 'contains'; Value = '' }"; Description = 'File name condition' }
                @{ Value = "@{ Property = 'System.ItemNameDisplay'; Operator = 'contains'; Value = '' }"; Description = 'Display name condition' }
                @{ Value = "@{ Property = 'System.Size'; Operator = 'greater than'; Value = ''; PropertyType = 'integer' }"; Description = 'Numeric size condition' }
                @{ Value = "@{ Property = 'System.DateModified'; Operator = 'after'; Value = ''; PropertyType = 'date' }"; Description = 'Date modified condition' }
            )
        }
    }

    foreach ($Item in $Values) {
        if ($Item.Value.StartsWith($WordToComplete, [System.StringComparison]::OrdinalIgnoreCase)) {
            [System.Management.Automation.CompletionResult]::new(
                $Item.Value,
                $Item.Value,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                $Item.Description
            )
        }
    }
}
