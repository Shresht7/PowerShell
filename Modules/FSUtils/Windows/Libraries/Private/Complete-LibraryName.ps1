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

    Get-Library | Where-Object {
        $_.Name.StartsWith(
            $WordToComplete,
            [System.StringComparison]::OrdinalIgnoreCase
        )
    } | ForEach-Object {
        [CompletionResult]::new(
            $_.Name,
            $_.Name,
            [CompletionResultType]::ParameterValue,
            "Library: $($_.Name); Folders: $($_.Folders)"
        )
    }
}
