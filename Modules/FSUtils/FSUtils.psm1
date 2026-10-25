# IMPORTS
# -------

# Import Private Functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}


# WINDOWS SPECIFIC MODULES
# ------------------------

if ($IsWindows) {
    . "$PSScriptRoot\Windows\Initialize.ps1"
}
