# Speech

PowerShell module to utilize speech synthesis using the .NET `System.Speech` library.

---

## 📕 Reference

### `Get-Voice`

Lists all installed text-to-speech (TTS) voices.

#### Examples

```powershell
Get-Voice
```

### `Out-Voice`

Uses text-to-speech to speak out the provided text.

#### Parameters

- `Text`: The text to speak out.
- `VoiceId`: (Optional) The ID of the voice to use. Defaults to the system default voice.
- `Rate`: (Optional) The speed of the speech (Range: -10 to 10, Default: 0).
- `Volume`: (Optional) The volume of the speech (Range: 0 to 100, Default: 100).

#### Examples

Speaks "Good Morning!" using the default voice.
```powershell
Out-Voice -Text "Good Morning!"
```

Speaks text at a higher speed and specific volume.
```powershell
Out-Voice -Text "Fast and loud" -Rate 5 -Volume 80
```

Pipe text directly to the speaker.
```powershell
"System update complete" | Out-Voice
```

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
