<#
.SYNOPSIS
    Symlinks scripts from the local `Scripts` folder to `$HOME\Scripts`
.DESCRIPTION
    Creates symbolic links for each script from the local `Scripts` folder to the `$HOME\Scripts` folder
.EXAMPLE
    . .\Link-Scripts.ps1
.NOTES
    This script requires either elevated permissions (administrator mode) or developer-mode to create symbolic links on Windows.
#>

# Import the Helper functions
Import-Module -Name "$PSScriptRoot\Modules\Utilities" -Cmdlet Test-IsElevated, Connect-Script
Import-Module -Name "$PSScriptRoot\Modules\FSUtils" -Cmdlet Find-Path

# Paths
$SOURCE_PATH = "$PSScriptRoot\Scripts"
$DESTINATION_PATH = "$HOME\Scripts"

# Get all Scripts
$Scripts = Get-ChildItem -Path $SOURCE_PATH -Filter "*.ps1" -Recurse

# Import Scripts
$Scripts | ForEach-Object {
    $Script = $_.FullName
    $Script | Connect-Script -Destination "$HOME\Scripts"
    $Script | Connect-Script -Destination "$HOME\Documents\PowerShell\Scripts"
}

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
