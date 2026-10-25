<#
.SYNOPSIS
    Removes a saved search
.DESCRIPTION
    Deletes a saved search
#>
function Remove-SavedSearch {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Search', 'SearchName')]
        [string] $Name
    )

    process {
        $Path = Resolve-SavedSearchPath $Name

        if ($PSCmdlet.ShouldProcess($Name, "Remove Saved Search")) {
            Remove-Item -LiteralPath $Path
        }
    }

}
