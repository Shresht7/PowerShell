<#
.SYNOPSIS
    Create XML for a saved search
.DESCRIPTION
    Generates XML for a saved search based on scope, conditions, and sort options.
#>
function New-SavedSearchXml {
    param(
        # Search Scope Paths
        [Parameter(Mandatory)] 
        [string[]] $Scope,

        # Search Conditions
        [Parameter(Mandatory)]
        [object[]] $Condition,

        # Search Kind
        [string] $Kind = 'item',
        
        # Sort Property
        [string] $SortBy = 'System.DateModified',

        # Sort Direction
        [ValidateSet('ascending', 'descending')]
        [string] $SortDirection = 'descending'
    )

    # Create XML document for saved search
    $Document = [System.Xml.XmlDocument]::new()
    $null = $Document.AppendChild($Document.CreateXmlDeclaration('1.0', 'utf-8', $null))

    # persistedQuery
    $PersistedQuery = $Document.CreateElement('persistedQuery')
    $PersistedQuery.SetAttribute('version', '1.0')
    $null = $Document.AppendChild($PersistedQuery)

    # viewInfo and sort
    $ViewInfo = $Document.CreateElement('viewInfo')
    $ViewInfo.SetAttribute('viewMode', 'details')
    $SortList = $Document.CreateElement('sortList')
    $Sort = $Document.CreateElement('sort')
    $Sort.SetAttribute('viewField', $SortBy)
    $Sort.SetAttribute('direction', $SortDirection)
    $null = $SortList.AppendChild($Sort)
    $null = $ViewInfo.AppendChild($SortList)
    $null = $PersistedQuery.AppendChild($ViewInfo)

    # query and conditions
    $Query = $Document.CreateElement('query')
    $Conditions = $Document.CreateElement('conditions')
    foreach ($Definition in $Condition) {
        $Item = Test-SavedSearchCondition -Condition $Definition
        $ConditionElement = $Document.CreateElement('condition')
        $ConditionElement.SetAttribute('type', 'leafCondition')
        $ConditionElement.SetAttribute('property', $Item.Property)
        $ConditionElement.SetAttribute('operator', $Item.Operator)
        $ConditionElement.SetAttribute('propertyType', $Item.PropertyType)
        $ConditionElement.SetAttribute('value', $Item.Value)
        $null = $Conditions.AppendChild($ConditionElement)
    }
    $null = $Query.AppendChild($Conditions)

    # kind list
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
    $null = $PersistedQuery.AppendChild($Query)

    # Return the constructed XML document
    $Document
}
