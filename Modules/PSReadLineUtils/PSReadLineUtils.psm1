# ===========================
# PSReadLineHistory Utilities
# ===========================

# Ensure PSReadLine is loaded before importing this module
if (-not (Get-Module -Name PSReadLine)) {
    throw "PSReadLine is required but not loaded. Please import PSReadLine before importing this module."
}

# Import Private functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

# Register a PSReadLine key handler for Ctrl+Shift+K to remove the current line from the history and the console
Set-PSReadLineKeyHandler -Key Ctrl+Shift+K `
    -BriefDescription "Removes the item from the console and the PSReadLineHistory" `
    -ScriptBlock {
    param ($Key, $Arg)

    $Line = $null
    $Cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

    # Remove the item from the PSReadLineHistory
    Remove-PSReadLineHistoryItem -Command $Line

    # Remove the item from the prompt
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()

    # Accept the empty line and move the prompt forward
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()

    # Write to the console that the item was removed
    Write-Host -ForegroundColor Red "Removed '$Line' from the PSReadLineHistory"

}
