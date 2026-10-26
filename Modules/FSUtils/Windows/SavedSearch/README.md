# SavedSearch

Windows saved-search utilities for creating and managing `.search-ms` files.

The commands use the current user's Searches folder:

```text
C:\Users\<User>\Searches
```

> The feature is loaded by the parent `FSUtils` module on Windows. It is not a standalone module.

## Commands

- `New-SavedSearch` - Create a saved search.
- `Get-SavedSearch` - Read saved-search definitions.
- `Set-SavedSearch` - Update selected parts of an existing search.
- `Rename-SavedSearch` - Rename a search without changing its contents.
- `Open-SavedSearch` - Open a search or the Searches folder in Explorer.
- `Remove-SavedSearch` - Delete a saved search.

## Create A Search


```powershell
New-SavedSearch `
    -Name 'PDF Documents' `
    -Scope 'C:\Users\Me\Documents' `
    -Condition @{
        Property = 'System.FileExtension'
        Operator = 'starts with'
        Value = '.pdf'
    }
```

> [!TIP]
> Multiple scopes and conditions are supported. Sibling conditions are treated by Windows Search as implicit `AND` conditions.

```powershell
$conditions = @(
    @{
        Property = 'System.FileExtension'
        Operator = 'starts with'
        Value = '.pdf'
    }
    @{
        Property = 'System.Size'
        Operator = 'greater than'
        Value = '1048576'
        PropertyType = 'integer'
    }
)

New-SavedSearch `
    -Name 'Large PDFs' `
    -Scope 'C:\Users\Me\Documents', 'C:\Users\Me\Downloads' `
    -Condition $conditions `
    -SortBy 'System.DateModified' `
    -SortDirection descending
```

## Condition Shape

Each condition must provide `Property`, `Operator`, and `Value`:

```powershell
@{
    Property = 'System.ItemNameDisplay'
    Operator = 'contains'
    Value = 'report'
}
```

`PropertyType` defaults to `string`. Supported values are:

- `string`
- `integer`
- `date`
- `boolean`
- `double`

Use the Windows Search property system name for `Property`. Common examples
include `System.FileExtension`, `System.ItemNameDisplay`, `System.Size`, and
`System.DateModified`.

## Update And Rename

`Set-SavedSearch` updates only the parameters supplied. Omitted values remain
unchanged.

```powershell
Set-SavedSearch -Name 'Large PDFs' -SortDirection ascending

Set-SavedSearch -Name 'Large PDFs' -Condition @()

Rename-SavedSearch -Name 'Large PDFs' -NewName 'Large PDF Documents'
```

An empty condition array clears all conditions. Empty scopes are rejected.
Use `-WhatIf` to preview updates, renames, and removals.

## Read And Open

```powershell
$search = Get-SavedSearch -Name 'Large PDF Documents'
$search.Scope
$search.Conditions
$search.Sort

Open-SavedSearch -Name 'Large PDF Documents'
```

`Get-SavedSearch` returns the parsed definition, including `Name`, `Path`,
`Scope`, `Kind`, `Conditions`, and `Sort`.

## File Format

`.search-ms` files are XML persisted-query documents consumed by Windows Explorer and Windows Search. 
A minimal generated definition has this shape:

```xml
<?xml version="1.0" encoding="utf-8"?>
<persistedQuery version="1.0">
  <viewInfo viewMode="details">
    <sortList>
      <sort viewField="System.DateModified" direction="descending" />
    </sortList>
  </viewInfo>
  <query>
    <conditions>
      <condition
        type="leafCondition"
        property="System.FileExtension"
        operator="starts with"
        propertyType="string"
        value=".pdf" />
    </conditions>
    <kindList>
      <kind name="item" />
    </kindList>
    <scope>
      <include path="C:\Users\Me\Documents" />
    </scope>
  </query>
</persistedQuery>
```

## References

- [Windows Search Structured Query Language](https://learn.microsoft.com/en-us/windows/win32/search/-search-sql)
- [System properties](https://learn.microsoft.com/en-us/windows/win32/properties/props)
