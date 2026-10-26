<#
.SYNOPSIS
    Opens a saved search in Explorer
.DESCRIPTION
    Opens a saved search in Explorer.
.EXAMPLE
    Open-SavedSearch -Name 'PDF Documents'
    Opens the named saved search in File Explorer.
.EXAMPLE
    Open-SavedSearch
    Opens the user's Searches folder in File Explorer.
.EXAMPLE
    Get-SavedSearch -Name 'PDF Documents' | Open-SavedSearch
    Opens a saved search received through the pipeline.
#>
function Open-SavedSearch {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Search', 'SearchName')]
        [string] $Name
    )

    process {
        $target = if ($Name) { Resolve-SavedSearchPath $Name } else { Get-SavedSearchPath }
        Write-Verbose "Opening $target"
        Start-Process explorer.exe -ArgumentList "`"$target`""
    }

}
