# Writer

Small utilities for writing and formatting text in the console.

## Commands

- `Get-ReversedString` - Reverse a string by Unicode text elements.
- `New-RandomString` - Generate a non-cryptographic random string.
- `Write-Box` - Draw a box around one or more lines of text.
- `Write-Heading` - Write a heading with configurable separator lines.
- `Write-Separator` - Draw a separator using a character or multi-character pattern.
- `Write-StatusMessage` - Write a status label and message with independent ANSI styles.
- `Write-TypeWriter` - Write text one character at a time.

## Examples

```powershell
Write-Box -Text @('Backup complete', 'Files: 42')

Write-Heading 'Deployment' -Double

Write-StatusMessage 'Deployment complete' `
    -Status 'DONE' `
    -StatusColor $PSStyle.Foreground.Green `
    -MessageColor $PSStyle.Bold
```

`New-RandomString` uses PowerShell's `Get-Random` and is not suitable for passwords,
tokens, or other security-sensitive values.
