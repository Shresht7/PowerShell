<#
.SYNOPSIS
    Symlinks scripts from the local `Scripts` folder to `$HOME\Scripts`
.DESCRIPTION
    Creates symbolic links for each script from the local `Scripts` folder to the `$HOME\Scripts` folder
.EXAMPLE
    . .\Link-Scripts.ps1
#>

# Import the Helper functions
Import-Module -Name "$PSScriptRoot\Modules\Utilities" -Cmdlet Test-IsElevated, Connect-Script
Import-Module -Name "$PSScriptRoot\Modules\FSUtils" -Cmdlet Find-Path

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
$Scripts | ForEach-Object {
    $Script = $_.FullName
    $Script | Connect-Script -Destination "$HOME\Scripts"
    $Script | Connect-Script -Destination "$HOME\Documents\PowerShell\Scripts"
}

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
