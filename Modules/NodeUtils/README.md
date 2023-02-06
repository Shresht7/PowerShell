# `NodeUtils`

This module provides a set of utilities for working with `node.js` projects.

## Cmdlets

### `Get-NpmGlobalPath`

Returns the path to the global `nodejs` folder.

### `Get-NpmScript`

Returns a list of scripts defined in the `package.json` file.

### `Get-PackageJson`

Returns the `package.json` file as a `PSCustomObject`.

### `Invoke-NpmScript`

Invokes a script defined in the `package.json` file. If no script is specified, use fzf to select one.

### `Remove-NodeModules`

Removes the selected `node_modules` folder. If no folder is specified, use fzf to select one.
