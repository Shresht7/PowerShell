# `Speech`

PowerShell Module to utilize speech synthesis.

---

## 📕 Reference

### `Get-Voice`

List installed text-to-speech (TTS) voices

### Examples

List all installed text-to-speech voices

```powershell
Get-Voice
```

### `Out-Voice`

Use text-to-speech to speak out the provided text

#### Parameters

- `Text`: The text to speak out

#### Examples

Speaks "Good Morning!"

```powershell
Out-Voice -Text "Good Morning!"
```

Can accept input from the pipeline. Speaks the current date

```powershell
Get-Date | Out-Voice
```

---

## 📄 License

This project is licensed under the [MIT License](.\LICENSE).
