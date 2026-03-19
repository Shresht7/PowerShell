# `NodeUtils`

This module provides a set of utilities for working with `node.js` projects.

## Cmdlets

### `Get-NpmScript`

Returns a list of scripts defined in the `package.json` file.

### `Get-PackageJson`

Returns the `package.json` file as a `PSCustomObject`.

### `Remove-NodeModules`

Removes the selected `node_modules` folder. If no folder is specified, use fzf to select one.
