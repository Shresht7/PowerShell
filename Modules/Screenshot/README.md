# `Screenshot`

This module provides functionality for capturing and managing screenshots in PowerShell.

---

## 📕 Reference

> Note: By default, the module assumes a folder named `Screenshots` in the `$HOME\Pictures` directory for storing the screenshots. You can modify the default folder or specify a different folder using the `-Folder` parameter or using the `Set-ScreenshotFolder` cmdlet.



### `Get-Screenshot`

Returns a list of all screenshots stored in the specified folder.

#### Parameters

- `Path`: The folder where the screenshots are located.
- `Filter`: Filter the list of screenshots based on a pattern.
- `Latest`: Retrieve the most recent screenshot.

#### Examples

Returns the list of all screenshots

```powershell
Get-Screenshot
```

Returns the list of all screenshots and opens the selected one

```powershell
Get-Screenshot | Invoke-Fzf | Invoke-Item
```

Opens the latest screenshot with the default application

```powershell
Get-Screenshot -Latest | Invoke-Item
```



### `Get-ScreenshotFolder`

Retrieves the path of the screenshot folder.

#### Examples

This example demonstrates how to use the `Get-ScreenshotFolder` function to retrieve the path of the screenshot folder.

```powershell
Get-ScreenshotFolder
```



### `New-Screenshot`

Captures a screenshot and saves it to the specified folder.

#### Parameters

- `Folder`: The folder where the screenshot should be saved.
- `Name`: The filename of the screenshot. If not specified, a default filename will be generated.
- `Open`: Indicates whether to open the screenshot after capturing it.

#### Examples

Captures a screenshot and saves it to the screenshot folder

```powershell
New-Screenshot
```

Captures a screenshot and opens it with the default application

```powershell
New-Screenshot -Open
```



### `Set-ScreenshotFolder`

Sets the path of the screenshot folder.

#### Parameters

- `Path`: Path to the new destination

#### Examples

Set the path to the new screenshot folder

```powershell
Set-ScreenshotFolder -Path "C:\Screenshots"
```



---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
