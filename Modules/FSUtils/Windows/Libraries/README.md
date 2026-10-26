# Windows Libraries

Windows Libraries are virtual folders backed by `.library-ms` files. 

This feature is loaded by the parent `FSUtils` module on Windows; it is not a standalone module.

```powershell
Import-Module FSUtils
```

## Commands

- `Get-Library` - List libraries and basic metadata.
- `New-Library` - Create a library.
- `Rename-Library` - Rename a non-default library.
- `Remove-Library` - Remove a non-default library.
- `Open-Library` - Open a library in Explorer.
- `Get-LibraryFolder` - List locations in a library.
- `Add-LibraryFolder` - Add an existing folder.
- `Remove-LibraryFolder` - Remove a folder or stale location.
- `Set-LibraryDefaultSaveFolder` - Set the default save location.
- `Export-Library` - Return or export a JSON definition.
- `Import-Library` - Create or merge a library from JSON.
- `Find-LibraryPath` - Find a library file.

The library files are stored in:

```text
$env:APPDATA\Microsoft\Windows\Libraries
```

## Basic Usage

```powershell
New-Library -Name Projects
Add-LibraryFolder -Name Projects -Path 'C:\Users\Me\Documents\Projects'
Add-LibraryFolder -Name Projects -Path 'D:\Project Archive'
Set-LibraryDefaultSaveFolder -Name Projects -Path 'C:\Users\Me\Documents\Projects'

Get-Library -Name Projects
Get-LibraryFolder -Name Projects
Open-Library -Name Projects
```

Library names are base names. Do not include the `.library-ms` extension when creating or renaming a library.

> [!NOTE]
> Default Windows libraries such as `Documents`, `Music`, `Pictures`, and `Videos` cannot be renamed or removed.

## Export And Import

Export a library as an object:

```powershell
$definition = Export-Library -Name Projects
$definition.Locations
```

Write the definition to JSON:

```powershell
Export-Library -Name Projects -Path '.\project-files.json'
```

Existing output files are not overwritten unless `-Force` is specified.
`-WhatIf` can be used to preview a file export.

Import the definition on another machine:

```powershell
Import-Library -Path '.\project-files.json'
```

Use `-Name` to override the name stored in the JSON file:

```powershell
Import-Library -Path '.\project-files.json' -Name 'Project Files Copy'
```

Use `-Merge` to add missing locations to an existing library. Import does not
remove locations already present in the target library.

Locations may contain ordinary filesystem paths, environment variables, or
`knownfolder:{GUID}` entries. Missing ordinary paths are skipped with a
warning. Known-folder entries are resolved through the Windows Shell API so
they continue to follow relocated Windows folders.

## Stale Locations

Windows Libraries can retain a location after its folder has been deleted.
`Get-LibraryFolder` still reports the stale entry, and `Remove-LibraryFolder`
can remove it without requiring the path to exist:

```powershell
Remove-LibraryFolder -Name Projects -Path 'D:\Project Archive'
```

By contrast, `Add-LibraryFolder` requires the supplied path to exist and be a
directory.

## Safety Features

Mutating commands support PowerShell confirmation behavior where appropriate:

```powershell
New-Library -Name Projects -WhatIf
Remove-Library -Name Projects -WhatIf
Rename-Library -Name Projects -NewName 'Projects' -WhatIf
Import-Library -Path '.\project-files.json' -WhatIf
```

`Remove-Library` has high confirmation impact and refuses default libraries.
`Rename-Library` refuses default libraries, invalid names, and name collisions.

## References

- [Library schema](https://learn.microsoft.com/en-us/windows/win32/shell/library-schema-entry)
- [IShellLibrary](https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-ishelllibrary)
