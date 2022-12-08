# Requires-Modules Utilities, FSUtils

<#
.SYNOPSIS
    Symlinks scripts from the local `Scripts` folder to `$HOME\Scripts`
.DESCRIPTION
    Creates symbolic links for each script from the local `Scripts` folder to the `$HOME\Scripts` folder
.EXAMPLE
    . .\Link-Scripts.ps1
#>

# Check to see if the script is running as administrator; exit if not
if (-Not (Test-IsElevated)) {
    Write-Error "Not in Administrator Mode! Elevated permissions are required to create Symbolic-Links"
    return
}

# Paths
$SOURCE_PATH = "$PSScriptRoot\Scripts"
$DESTINATION_PATH = "$HOME\Scripts"

# Get all Scripts
$Scripts = Get-ChildItem -Path $SOURCE_PATH -Filter "*.ps1" -Recurse

# Import Scripts
$Scripts.FullName | Connect-Script

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
