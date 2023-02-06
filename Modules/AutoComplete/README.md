# `AutoComplete`

This module provides a simple way to add custom auto-complete functionality to your PowerShell sessions.

---

## 📘 Usage

1. Import the module:

    ```powershell
    Import-Module -Name AutoComplete
    ```

2. Add a custom auto-complete function:

    ```powershell
    Register-CommandCompleter -Name npm -Tooltip "Node Package Manager" -Completions @(
        New-Completion -Name 'install' -Tooltip 'Install a package' -Completions @(
            New-Completion -Name '-g' -Tooltip 'Global'
            New-Completion -Name '--global' -Tooltip 'Global'
            New-Completion -Name '--save-dev' -Tooltip 'Save as dev-dependency'
        )
        New-Completion -Name "uninstall" -Tooltip "Uninstall a package"
    )
    ```

3. Use the auto-complete functionality:

    ```powershell
    npm <TAB>
    ```

> `Note`: Add your custom auto-complete functions to your PowerShell profile to make them available in all sessions.

---

## 📕 Reference

### `Register-CommandCompleter`

Registers a custom auto-complete function.

#### Parameters

- **Name**: The name of the command to register the auto-complete function for.
- **Tooltip**: The tooltip to display when the user presses `Ctrl+Space` while the cursor is on the command.
- **Completions**: An array of `Completion` objects to use for auto-completion.

### `New-Completion`

Creates a new `Completion` object.

#### Parameters

- **Name**: The name of the completion.
- **Tooltip**: The tooltip to display when the user presses `Ctrl+Space` while the cursor is on the completion.
- **Completions**: An array of `Completion` objects to use for auto-completion.
- **Script**: A script block to dynamically generate completions.
