<#
.SYNOPSIS
    Symlinks modules from the local `Modules` folder to the `$PSModulePath`
.DESCRIPTION
    Creates symbolic links for each module from the local `Modules` folder to the `$PSModulePath`
.EXAMPLE
    . .\Link-Modules.ps1
    This will create symbolic links for each module in the local `Modules` folder to the first path in `$PSModulePath`
.EXAMPLE
    . .\Link-Modules.ps1 -Confirm
    This will prompt for confirmation before creating each symbolic link.
.EXAMPLE
    . .\Link-Modules.ps1 -WhatIf
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

# Source Path
$SOURCE_PATH = "$PSScriptRoot\Modules"

# Windows and Linux have different delimiters apparently
$Delimiter = if ($PSVersionTable.OS -like "*Windows*") { ";" } else { ":" }

# Destination Path
$DESTINATION_PATH = $Env:PSModulePath.Split($Delimiter)[0]

# Ensure the destination path exists
if (-not (Test-Path $DESTINATION_PATH)) {
    Write-Error "Destination path '$DESTINATION_PATH' does not exist. Please ensure that the first path in `$PSModulePath is valid."
    exit 1
}

# Get all Modules
$Modules = Get-ChildItem -Path $SOURCE_PATH -Filter "*.psd1" -Recurse

# Import Modules
$Modules | ForEach-Object {
    if ($PSCmdlet.ShouldProcess("$DESTINATION_PATH\$($_.BaseName)", "Create Symbolic Link")) {
        New-Item -ItemType SymbolicLink -Path "$DESTINATION_PATH\$($_.BaseName)" -Target $_.DirectoryName -Force
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

