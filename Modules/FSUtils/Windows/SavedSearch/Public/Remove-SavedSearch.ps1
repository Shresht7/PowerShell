<#
.SYNOPSIS
    Removes a saved search
.DESCRIPTION
    Deletes a saved search
.EXAMPLE
    Remove-SavedSearch -Name 'PDF Documents'
    Prompts for confirmation and removes the named saved search.
.EXAMPLE
    Remove-SavedSearch -Name 'PDF Documents' -Confirm:$false
    Removes the named saved search without prompting for confirmation.
.EXAMPLE
    Remove-SavedSearch -Name 'PDF Documents' -WhatIf
    Shows what would happen without removing the saved search.
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
