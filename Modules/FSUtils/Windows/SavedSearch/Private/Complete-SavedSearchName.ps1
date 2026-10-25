<#
.SYNOPSIS
    Completes saved search names
.DESCRIPTION
    Completes saved search names based on input for tab completion
#>
function Complete-SavedSearchName {
    param([string] $WordToComplete)

    foreach ($file in Get-SavedSearchFile) {
        $name = $file.BaseName
        if ($name.StartsWith($WordToComplete, [System.StringComparison]::OrdinalIgnoreCase)) {
            $text = if ($name -match '\s') { "'$name'" } else { $name }

            [System.Management.Automation.CompletionResult]::new(
                $text,
                $name,
                [System.Management.Automation.CompletionResultType]::ParameterValue,
                "Saved Search: $name"
            )
        }
    }
}
