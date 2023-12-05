# `AutoComplete`

This module provides a simple way to add custom auto-complete functionality to pretty much anything in PowerShell.

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

        New-Completion -Name "run" -Tooltip "Run a script" -Script {
            (Get-NpmScript | ForEach-Object { New-Completion -Name $_.Name -Tooltip $_.Script }) 
        }

    )
    ```

    > Note: `Get-NpmScript` is a utility script to read the `package.json` from the present working directory and return the scripts. [See more](../NodeUtils/Library/Get-NpmScript.ps1)

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
- **Completions**: An array-list of `Completion` objects to use for auto-completion.

#### Example

```powershell
Register-CommandCompleter -Name 'test' -Tooltip 'Test Command' -Completions @(
    New-Completion -Name 'A'
    New-Completion -Name 'B' -Tooltip 'with sub-completions' -Completions @(
        New-Completion -Name 'B1'
    )
)
```

### `New-Completion`

Creates a new `Completion` object.

#### Parameters

- **Name**: The name of the completion.
- **Tooltip**: The tooltip to display when the user presses `Ctrl+Space` while the cursor is on the completion.
- **Completions**: An array of `Completion` objects to use for auto-completion.
- **ScriptBlock**: A script block to dynamically generate completions.

#### Examples

1. Create a basic completion
    ```powershell
    New-Completion -Name 'basic'
    ```
2. Create a completion with a tooltip
    ```powershell
    New-Completion -Name 'basic' -Tooltip 'additional information'
    ```
3. Create a completion with sub-completions
    ```powershell
    New-Completion -Name 'advanced' -Tooltip 'with sub-completions' -Completions @(
        New-Completion -Name 'sub-completion 1'
        New-Completion -Name 'sub-completion 2'
    )
    ```
4. Create a completion with dynamically generated sub-completions
    ```powershell
    New-Completion -Name 'advanced' -Tooltip 'with dynamic sub-completions' -ScriptBlock {
        1..5 | ForEach-Object { New-Completion -Name $_ }
    }
    ```
    > Note: You can have both normal and dynamic sub-completions
