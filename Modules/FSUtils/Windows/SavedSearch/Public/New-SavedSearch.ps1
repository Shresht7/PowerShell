<#
.SYNOPSIS
    Creates a Windows saved search
.DESCRIPTION
    Creates a .search-ms file in the user's Searches folder
.EXAMPLE
    New-SavedSearch -Name 'PDF Documents' `
        -Scope 'C:\Users\Me\Documents' `
        -Condition @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }
    Creates a saved search for PDF files under the Documents folder.
.EXAMPLE
    $conditions = @(
        @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' }
        @{ Property = 'System.Size'; Operator = 'greater than'; Value = '1048576'; PropertyType = 'integer' }
    )
    New-SavedSearch -Name 'Large PDFs' `
        -Scope 'C:\Users\Me\Documents', 'C:\Users\Me\Downloads' `
        -Condition $conditions `
        -SortBy 'System.DateModified' `
        -SortDirection descending
    Creates a saved search with multiple conditions and scopes.
.EXAMPLE
    New-SavedSearch -Name 'PDF Documents' `
        -Scope 'C:\Users\Me\Documents' `
        -Condition @{ Property = 'System.FileExtension'; Operator = 'starts with'; Value = '.pdf' } `
        -Force
    Replaces an existing saved search with the same name.
.EXAMPLE
    $search = Get-SavedSearch -Name 'Large PDFs'
    $search.Conditions
    $search.Sort
    Reads a saved search definition after it has been created.
#>
function New-SavedSearch {
    
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        # Name of the saved search file
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        # Scope paths to include
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Scope,

        # Conditions for the search
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object[]] $Condition,

        # Kind of items to search
        [ValidateNotNullOrEmpty()]
        [string] $Kind = 'item',

        # Sort by field
        [string] $SortBy = 'System.DateModified',

        # Sort direction
        [ValidateSet('ascending', 'descending')]
        [string] $SortDirection = 'descending',

        # Overwrite if exists
        [switch] $Force
    )

    # Get path for saved searches
    Test-SavedSearchName -Name $Name | Out-Null
    $SearchesPath = Get-SavedSearchPath
    $Path = Join-Path $SearchesPath "$Name.search-ms"

    # Check if exists
    if ((Test-Path -LiteralPath $Path) -and -not $Force) {
        throw "Saved search '$Name' already exists. Use -Force to overwrite it."
    }

    # Validate scope entries
    foreach ($Item in $Scope) {
        if ([string]::IsNullOrWhiteSpace($Item)) {
            throw 'Scope entries cannot be empty.'
        }
    }

    # Create .search-ms file
    if ($PSCmdlet.ShouldProcess($Path, 'Create saved search')) {
        $Document = New-SavedSearchXml `
            -Scope $Scope `
            -Condition $Condition `
            -Kind $Kind `
            -SortBy $SortBy `
            -SortDirection $SortDirection
        Write-SavedSearchDefinition -Document $Document -Path $Path
        Get-Item -LiteralPath $Path
    }
}
