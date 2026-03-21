# Theme Module

PowerShell cmdlets for managing Windows Light/Dark theme settings for both System and Applications.

## Functions

### `Get-Theme`
Retrieves the current Windows Color Theme status.

**Usage:**
```powershell
# Get status for both System and Apps (as an object)
Get-Theme

# Get System theme as a string ("Light" or "Dark")
Get-Theme -Target System -AsString

# Get App theme as a boolean (True for Light, False for Dark)
Get-Theme -Target App -AsBoolean
```

### `Set-Theme`
Sets the Windows theme to Light or Dark mode.

**Usage:**
```powershell
# Set both System and Apps to Dark mode
Set-Theme -Dark

# Set only the System theme to Light mode
Set-Theme -Light -Target System
```

### `Switch-Theme`
Toggles between Light and Dark modes.

**Usage:**
```powershell
# Toggle both System and Apps based on current System theme
Switch-Theme

# Toggle only the App theme
Switch-Theme -Target App
```
