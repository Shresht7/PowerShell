# Requires-Modules Utilities, FSUtils

<#
.SYNOPSIS
    Links the scripts to Scripts folder
.DESCRIPTION
    Creates symlinks for the scripts to the Scripts folder
.EXAMPLE
    . .\Link-Scripts.ps1
#>

# Check to see if the script is running as administrator; exit if not
if (-Not (Test-IsElevated)) {
    Write-Error "Not in Administrator Mode!"
    return
}

# Paths
$SOURCE_PATH = "$PSScriptRoot\Scripts"
$DESTINATION_PATH = "$HOME\Scripts"

# Get all Scripts
$Scripts = Get-ChildItem -Path $SOURCE_PATH -Recurse | Where-Object {
    $_.Extension -eq ".ps1"
}

# Import Scripts
$Scripts | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$DESTINATION_PATH\$($_.Name)" -Target $_.FullName -Force
}

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
