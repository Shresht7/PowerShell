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
    Get-ChildItem -Path "$PSScriptRoot\Windows\Libraries" -Recurse -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
    }
}
