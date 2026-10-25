<#
.SYNOPSIS
    Gets saved searches
.DESCRIPTION
    Gets saved searches from the default saved search location.
    (USERPROFILE\Searches) by default.
#>
function Get-SavedSearch {

    [CmdletBinding()]
    param(
        # Name of the saved search (all if omitted)
        [Alias('Search', 'SearchName')]
        [string] $Name
    )

    foreach ($file in Get-SavedSearchFile -Name $Name) {
        $xml = Read-SavedSearchDefinition -Path $file.FullName

        $conditions = foreach ($c in $xml.SelectNodes('//conditions//condition[@type="leafCondition"]')) {
            [PSCustomObject]@{
                Property  = $c.GetAttribute('property')
                Operation = $c.GetAttribute('operation')
                Value     = $c.GetAttribute('value')
            }
        }

        $sort = foreach ($s in $xml.SelectNodes('//sortList/sort')) {
            [PSCustomObject]@{
                Property  = $s.GetAttribute('viewField')
                Direction = $s.GetAttribute('direction')
            }
        }

        [PSCustomObject]@{
            PSTypeName = 'PSFSUtils.WindowsSavedSearch.SavedSearch'
            Name       = $file.BaseName
            Path       = $file.FullName
            Scope      = @($xml.SelectNodes('//scope/include')).ForEach({ $_.GetAttribute('path') })
            Kind       = @($xml.SelectNodes('//kindList/kind')).ForEach({ $_.GetAttribute('name') })
            Conditions = @($conditions)
            Sort       = @($sort)
        }
    }

}
