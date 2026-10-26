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
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[^\\/:*?"<>|]+$')]
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

    # Create XML document
    $Document = [System.Xml.XmlDocument]::new()
    $Declaration = $Document.CreateXmlDeclaration('1.0', 'utf-8', $null)
    $null = $Document.AppendChild($Declaration)

    # persistedQuery
    $PersistedQuery = $Document.CreateElement('persistedQuery')
    $PersistedQuery.SetAttribute('version', '1.0')
    $null = $Document.AppendChild($PersistedQuery)

    # viewInfo
    $ViewInfo = $Document.CreateElement('viewInfo')
    $ViewInfo.SetAttribute('viewMode', 'details')
    $null = $PersistedQuery.AppendChild($ViewInfo)

    # sortList
    $SortList = $Document.CreateElement('sortList')
    $Sort = $Document.CreateElement('sort')
    $Sort.SetAttribute('viewField', $SortBy)
    $Sort.SetAttribute('direction', $SortDirection)
    $null = $SortList.AppendChild($Sort)
    $null = $ViewInfo.AppendChild($SortList)

    # query
    $Query = $Document.CreateElement('query')
    $null = $PersistedQuery.AppendChild($Query)

    # conditions
    $Conditions = $Document.CreateElement('conditions')
    foreach ($Definition in $Condition) {
        $ValidatedCondition = Test-SavedSearchCondition -Condition $Definition

        $ConditionElement = $Document.CreateElement('condition')
        $ConditionElement.SetAttribute('type', 'leafCondition')
        $ConditionElement.SetAttribute('property', $ValidatedCondition.Property)
        $ConditionElement.SetAttribute('operator', $ValidatedCondition.Operator)
        $ConditionElement.SetAttribute('propertyType', $ValidatedCondition.PropertyType)
        $ConditionElement.SetAttribute('value', $ValidatedCondition.Value)
        $null = $Conditions.AppendChild($ConditionElement)
    }
    $null = $Query.AppendChild($Conditions)

    # kindList
    $KindList = $Document.CreateElement('kindList')
    $KindElement = $Document.CreateElement('kind')
    $KindElement.SetAttribute('name', $Kind)
    $null = $KindList.AppendChild($KindElement)
    $null = $Query.AppendChild($KindList)

    # scope
    $ScopeElement = $Document.CreateElement('scope')
    foreach ($Item in $Scope) {
        $Include = $Document.CreateElement('include')
        $Include.SetAttribute('path', $Item)
        $null = $ScopeElement.AppendChild($Include)
    }
    $null = $Query.AppendChild($ScopeElement)

    # Create .search-ms file
    if ($PSCmdlet.ShouldProcess($Path, 'Create saved search')) {
        $Settings = [System.Xml.XmlWriterSettings]::new()
        $Settings.Encoding = [System.Text.UTF8Encoding]::new($false)
        $Settings.Indent = $true

        $Writer = [System.Xml.XmlWriter]::Create($Path, $Settings)
        try {
            $Document.Save($Writer)
        }
        finally {
            $Writer.Dispose()
        }

        Get-Item -LiteralPath $Path
    }
}
