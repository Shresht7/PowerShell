# Import Private Functions
Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Public" -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}

# -----------------
# WINDOWS LIBRARIES
# -----------------

if ($IsWindows) {
    . "$PSScriptRoot\Windows\Initialize-WindowsFSUtils.ps1"
    . "$PSScriptRoot\Windows\Libraries\Initialize-Libraries.ps1"
}
