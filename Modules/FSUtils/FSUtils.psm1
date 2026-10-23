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

    # Private
    Get-ChildItem -Path "$PSScriptRoot\Libraries\Private" -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
    }

    # Public
    Get-ChildItem -Path "$PSScriptRoot\Libraries\Public" -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
    }

}
