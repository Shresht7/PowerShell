# `Screenshot`

This module provides functionality for capturing and managing screenshots in PowerShell.

---

## 📘 Usage

1. Import the module:

    ```powershell
    Import-Module -Name Screenshot
    ```

2. Capture a new screenshot

    ```powershell
    New-Screenshot
    ```

3. Retrieve a list of screenshots

    ```powershell
    Get-Screenshot
    ```

---

## 📕 Reference

> Note: By default, the module assumes a folder named `Screenshots` in the `$HOME\Pictures` directory for storing the screenshots. You can modify the default folder or specify a different folder using the -Folder parameter.

### New-Screenshot

Captures a screenshot and saves it to the specified folder.

#### Parameters

**Folder**: The folder where the screenshot should be saved.
**Name**: The filename of the screenshot. If not specified, a default filename will be generated.
**Open**: Indicates whether to open the screenshot after capturing it.

### Get-Screenshot

Returns a list of all screenshots stored in the specified folder.

#### Parameters
**Path**: The folder where the screenshots are located.
**Filter**: Filter the list of screenshots based on a pattern.
**Latest**: Retrieve the most recent screenshot.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
