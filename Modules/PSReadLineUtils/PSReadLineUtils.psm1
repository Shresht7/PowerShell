# ===========================
# PSReadLineHistory Utilities
# ===========================

# Ensure PSReadLine is loaded before importing this module
if (-not (Get-Module -Name PSReadLine)) {
    throw "PSReadLine is required but not loaded. Please import PSReadLine before importing this module."
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}
