# PowerShell

A collection of PowerShell functions, scripts and modules.

## Repository

- [`Modules/`](./Modules/) - PowerShell modules
- [`Scripts/`](./Scripts/) - Standalone PowerShell scripts
- [`Link-Modules.ps1`](./Link-Modules.ps1) - Symlinks modules to `$PSModulePath`
- [`Link-Scripts.ps1`](./Link-Scripts.ps1) - Symlinks scripts to `$HOME\Scripts`

---

## Modules

### [Backup](./Modules/Backup/) `v0.0.1`
Simple backup utility.

- `Backup-Item`, `Get-Backup`, `Remove-Backup`, `Restore-ItemFromBackup`, `Show-BackupStatus`

### [Completions](./Modules/Completions/) `v0.0.1`
Tab-completers for CLI tools (cargo, code, fd, go, npm, scoop).

### [FSUtils](./Modules/FSUtils/) `v1.0.0`
A collection of file-system utilities.

- `Get-BrokenSymlink`, `Get-GitRepo`, `Get-Size`, `Get-SpecialFolders`, `Move-ItemAndCreateLink`, `Set-LocationFuzzy`, `Set-LocationToHome`, `Test-IsSymbolicLink`, `New-Shortcut`, `Enter-NewDirectory`
- **Windows:** `Get-DesktopIconVisibility`, `Get-FileVisibility`, `Get-Library`, `Invoke-Library`, `Switch-FileVisibility`

### [NetworkUtils](./Modules/NetworkUtils/) `v0.0.1`
Network utility functions.

- `Wait-OnInternetConnection`

### [NodeUtils](./Modules/NodeUtils/) `v1.0.0`
Utilities for Node.js projects.

- `Get-PackageJson`, `Get-NpmScript`, `Remove-NodeModules`, `Get-NodeProject`
- **Requires:** [FSUtils](./Modules/FSUtils/)

### [PSReadLineUtils](./Modules/PSReadLineUtils/) `v1.0.0`
Utilities for PSReadLine command history management.

- `Backup-PSReadLineHistory`, `Clear-PSReadLineHistoryBackups`, `Get-PSReadLineHistory`, `Get-PSReadLineHistoryFrequency`, `Get-PSReadLineHistoryPath`, `Optimize-PSReadLineHistory`, `Remove-PSReadLineHistoryItem`, `Set-PSReadLineHistory`
- Includes a Pester test suite.

### [Reminders](./Modules/Reminders/) `v0.1.0`
Create reminders using Windows scheduled tasks.

- `Get-Reminder`, `Set-Reminder`, `Remove-Reminder`, `Clear-CompletedReminders`

### [Screenshot](./Modules/Screenshot/) `v1.0.0`
Create and manage screenshots.

- `Get-Screenshot`, `Get-ScreenshotFolder`, `New-Screenshot`, `Set-ScreenshotFolder`

### [Speech](./Modules/Speech/) `v0.2.0`
Text-to-speech synthesis (Windows-only).

- `Get-Voice`, `Out-Voice`

### [System-Information](./Modules/System-Information/) `v1.0.0`
Hardware and system information via CIM/WMI (Windows-only).

- `Get-BaseBoard`, `Get-BatteryStatus`, `Get-BIOS`, `Get-DiskDrive`, `Get-LastBootupTime`, `Get-LogicalDisk`, `Get-NetworkAdapter`, `Get-OperatingSystem`, `Get-PhysicalMemory`, `Get-Processor`, `Get-VideoController`

### [Theme](./Modules/Theme/) `v0.1.0`
Manage Windows light/dark theme settings.

- `Get-AccentColor`, `Get-Theme`, `Set-Theme`, `Switch-Theme`

### [Utilities](./Modules/Utilities/) `v0.0.1`
General-purpose utility functions.

- `Find-Path`, `Get-HelpExample`, `Import-Json`, `Invoke-Script`, `Open-Project`, `Read-Choice`, `Reset-Module`, `Search-Command`, `Search-FullText`, `Select-FuzzyObject`, `Show-Preview`, `Start-App`, `Test-IsElevated`, `Wait-Host`, `Watch-Command`
- **Env:** `Add-ToEnvPath`, `Find-EnvPath`, `Get-EnvPath`, `Test-InEnvPath`
- **Link:** `Connect-Module`, `Connect-Script`
- **Strings:** `ConvertFrom-EncodedString`, `ConvertTo-EncodedString`, `Limit-String`, `Split-String`

### [Web](./Modules/Web/) `v1.1.0`
Search the web and manage browser bookmarks.

- `Get-Bookmarks`, `Get-BookmarksPath`, `Get-BrowserDataPath`, `Get-DefaultBrowser`, `Search-Web`

### [Writer](./Modules/Writer/) `v0.1.0`
Utilities for writing strings to the console.

- `Get-ReversedString`, `New-RandomString`, `Write-Separator`, `Write-TypeWriter`

---

## Scripts

### [Checkpoint-BatteryReport.ps1](./Scripts/Checkpoint-BatteryReport.ps1)
Records the battery report from `powercfg`.

### Git

- [**Write-ConventionalCommit.ps1**](./Scripts/Git/Write-ConventionalCommit.ps1) - Write a conventional commit message

### GitHub

- [**Get-GitHubGist.ps1**](./Scripts/GitHub/Get-GitHubGist.ps1) - Get the content of a file in a GitHub Gist

### Network

- [**Notify-InternetConnectionRestored.ps1**](./Scripts/Network/Notify-InternetConnectionRestored.ps1) - Notify the user when the internet connection is restored

### Reference

- [**Learn-X-in-Y-Minutes.ps1**](./Scripts/Reference/Learn-X-in-Y-Minutes.ps1) - Fuzzy search and display Learn X in Y Minutes documentation
- [**Show-CheatSheet.ps1**](./Scripts/Reference/Show-CheatSheet.ps1) - Invoke the cheat.sh API
- [**Show-TLDR.ps1**](./Scripts/Reference/Show-TLDR.ps1) - Interactive fuzzy selector for tldr pages

### Tools

- [**Preview-BatThemes.ps1**](./Scripts/Tools/bat/Preview-BatThemes.ps1) - Preview the themes available for bat

---

## License

<!--
Individual modules and scripts may have their own licenses. See the `LICENSE` file in each module directory for details.
-->

This repository is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
