<#
.SYNOPSIS
    Updates an existing Windows saved search.
.DESCRIPTION
    Updates only the properties supplied and preserves the remaining definition.
.EXAMPLE
    Set-SavedSearch -Name 'PDF Documents' -SortDirection ascending
    Changes the sort direction without changing the search conditions or scope.
.EXAMPLE
    Set-SavedSearch -Name 'PDF Documents' -Condition @{
        Property = 'System.FileExtension'
        Operator = 'starts with'
        Value = '.pdf'
    }
    Replaces the existing conditions with the supplied condition.
#>
function Set-SavedSearch {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        # Name of the saved search file (without extension)
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('Search', 'SearchName')]
        [string] $Name,

        # Scope paths to include (array of paths)
        [ValidateNotNullOrEmpty()]
        [string[]] $Scope,

        # Conditions for the search (array of hashtables)
        [object[]] $Condition,

        # Kind of items to include (e.g., item)
        [ValidateNotNullOrEmpty()]
        [string] $Kind,

        # Sort property
        [string] $SortBy,

        # Sort direction (ascending/descending)
        [ValidateSet('ascending', 'descending')]
        [string] $SortDirection
    )

    process {
        $Path = Resolve-SavedSearchPath $Name
        $Xml = Read-SavedSearchDefinition -Path $Path
        $Query = $Xml.SelectSingleNode('/persistedQuery/query')

        if ($null -eq $Query) {
            throw "Saved search '$Name' does not contain a query definition."
        }

        $Changes = @($PSBoundParameters.Keys | Where-Object { $_ -ne 'Name' })
        if ($Changes.Count -eq 0) {
            throw 'Specify at least one property to update.'
        }

        if ($PSBoundParameters.ContainsKey('Scope')) {
            foreach ($Item in $Scope) {
                if ([string]::IsNullOrWhiteSpace($Item)) {
                    throw 'Scope entries cannot be empty.'
                }
            }
        }

        $ValidatedConditions = if ($PSBoundParameters.ContainsKey('Condition')) {
            @($Condition | ForEach-Object { Test-SavedSearchCondition -Condition $_ })
        }

        if ($PSCmdlet.ShouldProcess($Path, 'Update saved search')) {
            if ($PSBoundParameters.ContainsKey('Scope')) {
                $ScopeElement = $Query.SelectSingleNode('./scope')
                if ($null -eq $ScopeElement) {
                    $ScopeElement = $Xml.CreateElement('scope')
                    $null = $Query.AppendChild($ScopeElement)
                }
                $ScopeElement.RemoveAll()
                foreach ($Item in $Scope) {
                    $Include = $Xml.CreateElement('include')
                    $Include.SetAttribute('path', $Item)
                    $null = $ScopeElement.AppendChild($Include)
                }
            }

            if ($PSBoundParameters.ContainsKey('Condition')) {
                $ConditionsElement = $Query.SelectSingleNode('./conditions')
                if ($null -eq $ConditionsElement) {
                    $ConditionsElement = $Xml.CreateElement('conditions')
                    $null = $Query.PrependChild($ConditionsElement)
                }
                $ConditionsElement.RemoveAll()
                foreach ($Item in $ValidatedConditions) {
                    $ConditionElement = $Xml.CreateElement('condition')
                    $ConditionElement.SetAttribute('type', 'leafCondition')
                    $ConditionElement.SetAttribute('property', $Item.Property)
                    $ConditionElement.SetAttribute('operator', $Item.Operator)
                    $ConditionElement.SetAttribute('propertyType', $Item.PropertyType)
                    $ConditionElement.SetAttribute('value', $Item.Value)
                    $null = $ConditionsElement.AppendChild($ConditionElement)
                }
            }

            if ($PSBoundParameters.ContainsKey('Kind')) {
                $KindList = $Query.SelectSingleNode('./kindList')
                if ($null -eq $KindList) {
                    $KindList = $Xml.CreateElement('kindList')
                    $null = $Query.AppendChild($KindList)
                }
                $KindList.RemoveAll()
                $KindElement = $Xml.CreateElement('kind')
                $KindElement.SetAttribute('name', $Kind)
                $null = $KindList.AppendChild($KindElement)
            }

            if ($PSBoundParameters.ContainsKey('SortBy') -or $PSBoundParameters.ContainsKey('SortDirection')) {
                $ViewInfo = $Xml.SelectSingleNode('/persistedQuery/viewInfo')
                if ($null -eq $ViewInfo) {
                    $ViewInfo = $Xml.CreateElement('viewInfo')
                    $null = $Xml.DocumentElement.PrependChild($ViewInfo)
                }
                $SortList = $ViewInfo.SelectSingleNode('./sortList')
                if ($null -eq $SortList) {
                    $SortList = $Xml.CreateElement('sortList')
                    $null = $ViewInfo.AppendChild($SortList)
                }
                $Sort = $SortList.SelectSingleNode('./sort')
                if ($null -eq $Sort) {
                    $Sort = $Xml.CreateElement('sort')
                    $null = $SortList.AppendChild($Sort)
                }
                if ($PSBoundParameters.ContainsKey('SortBy')) {
                    $Sort.SetAttribute('viewField', $SortBy)
                }
                if ($PSBoundParameters.ContainsKey('SortDirection')) {
                    $Sort.SetAttribute('direction', $SortDirection)
                }
            }

            Write-SavedSearchDefinition -Document $Xml -Path $Path

            Get-Item -LiteralPath $Path
        }
    }
}
