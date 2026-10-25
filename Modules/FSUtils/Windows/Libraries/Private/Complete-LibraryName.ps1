<#
.SYNOPSIS
    Completes library names for tab completion
.DESCRIPTION
    Completes library names for tab completion in PowerShell
    Used by argument completers for library commands like Get-Library and Open-Library
#>
function Complete-LibraryName {
    param(
        [string] $WordToComplete
    )

    foreach ($Library in Get-Library) {
        if ($Library.Name.StartsWith($WordToComplete, [System.StringComparison]::OrdinalIgnoreCase)) {
            [CompletionResult]::new(
                $Library.Name,
                $Library.Name,
                [CompletionResultType]::ParameterValue,
                "Library: $($Library.Name); Folders: $($Library.FolderCount)"
            )
        }
    }
}
