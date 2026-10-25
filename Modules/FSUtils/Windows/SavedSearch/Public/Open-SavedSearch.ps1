<#
.SYNOPSIS
    Opens a saved search in Explorer
.DESCRIPTION
    Opens a saved search in Explorer.
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
