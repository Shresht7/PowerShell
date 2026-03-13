<#
.SYNOPSIS
    Symlinks scripts from the local `Scripts` folder to `$HOME\Scripts`
.DESCRIPTION
    Creates symbolic links for each script from the local `Scripts` folder to the `$HOME\Scripts` folder
.EXAMPLE
    . .\Link-Scripts.ps1
    This will create symbolic links for each script in the local `Scripts` folder to the `$HOME\Scripts` folder
.EXAMPLE
    . .\Link-Scripts.ps1 -Confirm
    This will prompt for confirmation before creating each symbolic link.
.EXAMPLE
    . .\Link-Scripts.ps1 -WhatIf
    This will simulate the actions without making any changes, showing what symbolic links would be created.
.NOTES
    This script requires either elevated permissions (administrator mode) or developer-mode to create symbolic links on Windows.
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
param (
    # Confirm before creating symlinks
    [switch] $Confirm,

    # WhatIf to simulate the actions without making changes
    [switch] $WhatIf
)

# Import the Helper functions
Import-Module -Name "$PSScriptRoot\Modules\Utilities" -Cmdlet Test-IsElevated, Connect-Script
Import-Module -Name "$PSScriptRoot\Modules\FSUtils" -Cmdlet Find-Path

# Paths
$SOURCE_PATH = "$PSScriptRoot\Scripts"
$DESTINATION_PATH = @("$HOME\Scripts", "$HOME\Documents\PowerShell\Scripts")

# Get all Scripts
$Scripts = Get-ChildItem -Path $SOURCE_PATH -Filter "*.ps1" -Recurse

# Import Scripts
$Scripts | ForEach-Object {
    foreach ($Destination in $DESTINATION_PATH) {
        if ($PSCmdlet.ShouldProcess("$Destination\$($_.Name)", "Create Symbolic Link")) {
            New-Item -ItemType SymbolicLink -Path "$Destination\$($_.Name)" -Target $_.FullName -Force
        }
    }
}

# Remove Broken Symlinks
Get-ChildItem -Path $DESTINATION_PATH -Recurse |
Where-Object { $_.LinkType -eq "SymbolicLink" -and -not (Test-Path -Path $_.LinkTarget) } |
ForEach-Object {
    if ($PSCmdlet.ShouldProcess($_.FullName, "Remove Broken Symbolic Link")) {
        Remove-Item -Path $_.FullName -Force
    }
}
