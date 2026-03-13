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
param ()

# Paths
$SOURCE_PATH = "$PSScriptRoot\Scripts"
$DESTINATION_PATH = @("$HOME\Scripts", "$HOME\Documents\PowerShell\Scripts")

# Ensure that the destination paths exist
foreach ($Destination in $DESTINATION_PATH) {
    if (-not (Test-Path $Destination)) {
        Write-Error "Destination path '$Destination' does not exist. Please ensure that the path is valid."
        exit 1
    }
}

# Get everything directly under the Scripts folder
$Items = Get-ChildItem -Path $SOURCE_PATH

# Link it
$Items | ForEach-Object {
    foreach ($Destination in $DESTINATION_PATH) {
        $LinkPath = Join-Path $Destination $_.Name
        if ($PSCmdlet.ShouldProcess($LinkPath, "Create Symbolic Link")) {
            New-Item -ItemType SymbolicLink -Path $LinkPath -Target $_.FullName -Force
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
