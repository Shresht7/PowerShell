<#
.SYNOPSIS
    Creates a Windows saved search.
.DESCRIPTION
    Creates a .search-ms file in the user's Searches folder.
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

    # Create XML document
    $Document = [System.Xml.XmlDocument]::new()
    $Declaration = $Document.CreateXmlDeclaration('1.0', 'utf-8', $null)
    $null = $Document.AppendChild($Declaration)

    $PersistedQuery = $Document.CreateElement('persistedQuery')
    $PersistedQuery.SetAttribute('version', '1.0')
    $null = $Document.AppendChild($PersistedQuery)

    $ViewInfo = $Document.CreateElement('viewInfo')
    $ViewInfo.SetAttribute('viewMode', 'details')
    $null = $PersistedQuery.AppendChild($ViewInfo)

    $SortList = $Document.CreateElement('sortList')
    $Sort = $Document.CreateElement('sort')
    $Sort.SetAttribute('viewField', $SortBy)
    $Sort.SetAttribute('direction', $SortDirection)
    $null = $SortList.AppendChild($Sort)
    $null = $ViewInfo.AppendChild($SortList)

    $Query = $Document.CreateElement('query')
    $null = $PersistedQuery.AppendChild($Query)

    $Conditions = $Document.CreateElement('conditions')
    foreach ($Definition in $Condition) {
        if ($Definition -is [System.Collections.IDictionary]) {
            $Property = if ($Definition.ContainsKey('Property')) { $Definition['Property'] }
            $Operator = if ($Definition.ContainsKey('Operator')) { $Definition['Operator'] }
            $Value = if ($Definition.ContainsKey('Value')) { $Definition['Value'] }
            $PropertyType = if ($Definition.ContainsKey('PropertyType')) { $Definition['PropertyType'] }
        }
        else {
            $Property = $Definition.PSObject.Properties['Property'].Value
            $Operator = $Definition.PSObject.Properties['Operator'].Value
            $Value = $Definition.PSObject.Properties['Value'].Value
            $PropertyType = $Definition.PSObject.Properties['PropertyType'].Value
        }

        if ([string]::IsNullOrWhiteSpace([string] $Property) -or
            [string]::IsNullOrWhiteSpace([string] $Operator) -or
            $null -eq $Value) {
            throw 'Each condition must contain Property, Operator, and Value.'
        }

        if ([string]::IsNullOrWhiteSpace([string] $PropertyType)) {
            $PropertyTypeValue = 'string'
        }
        else {
            $PropertyTypeValue = [string] $PropertyType
        }

        $ConditionElement = $Document.CreateElement('condition')
        $ConditionElement.SetAttribute('type', 'leafCondition')
        $ConditionElement.SetAttribute('property', [string] $Property)
        $ConditionElement.SetAttribute('operator', [string] $Operator)
        $ConditionElement.SetAttribute('propertyType', $PropertyTypeValue)
        $ConditionElement.SetAttribute('value', [string] $Value)
        $null = $Conditions.AppendChild($ConditionElement)
    }
    $null = $Query.AppendChild($Conditions)

    $KindList = $Document.CreateElement('kindList')
    $KindElement = $Document.CreateElement('kind')
    $KindElement.SetAttribute('name', $Kind)
    $null = $KindList.AppendChild($KindElement)
    $null = $Query.AppendChild($KindList)

    $ScopeElement = $Document.CreateElement('scope')
    foreach ($Item in $Scope) {
        $Include = $Document.CreateElement('include')
        $Include.SetAttribute('path', $Item)
        $null = $ScopeElement.AppendChild($Include)
    }
    $null = $Query.AppendChild($ScopeElement)

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
