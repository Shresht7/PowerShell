# PSReadLineUtils

Utilities for managing PSReadLine history.

## Installation

```powershell
# Clone or copy to your PowerShell modules directory
# Then import the module:
Import-Module PSReadLineUtils
```

## Functions

### Backup-PSReadLineHistory

Creates a backup of the PSReadLine history file.

```powershell
# Create a backup with timestamp
Backup-PSReadLineHistory

# Backup to custom location
Backup-PSReadLineHistory -Destination "C:\Backups\my-history.txt"
```

### Get-PSReadLineHistory

Returns the contents of the PSReadLine history file.

```powershell
# Get all history
Get-PSReadLineHistory

# Get raw contents (no processing)
Get-PSReadLineHistory -Raw

# Get unique commands only
Get-PSReadLineHistory -Unique

# Filter commands
Get-PSReadLineHistory -Filter "Get-Service"
```

### Get-PSReadLineHistoryPath

Returns the path to the PSReadLine history file.

```powershell
# Get history file path
Get-PSReadLineHistoryPath

# Get parent directory
Get-PSReadLineHistoryPath -Type Directory
```

### Get-PSReadLineHistoryFrequency

Returns command frequency counts from history.

```powershell
# Get frequency sorted by count (descending)
Get-PSReadLineHistoryFrequency

# Get top 10 most used commands
Get-PSReadLineHistoryFrequency -Top 10
```

### Set-PSReadLineHistory

Sets (overwrites) the contents of the PSReadLine history file.

```powershell
# Set history contents
$History | Set-PSReadLineHistory

# Append to history
Set-PSReadLineHistory -Content "new command" -Append
```

### Remove-PSReadLineHistoryItem

Removes items from the PSReadLine history.

```powershell
# Remove by command name
Remove-PSReadLineHistoryItem -Command "Get-Service"

# Remove last 10 items
Remove-PSReadLineHistoryItem -Count 10

# Remove duplicates
Remove-PSReadLineHistoryItem -Duplicate
```

### Optimize-PSReadLineHistory

Optimizes the history file by removing duplicates and trimming to max lines.

```powershell
# Optimize with defaults (10,000 lines max)
Optimize-PSReadLineHistory

# Optimize to 1,000 lines
Optimize-PSReadLineHistory -MaxLineCount 1000
```

## Key Bindings

- **Ctrl+Shift+K** - Removes the current command from history after execution

Requires PowerShell 5.1+ and PSReadLine module.