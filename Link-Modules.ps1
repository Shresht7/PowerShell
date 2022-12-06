# Requires-Modules Utilities, FSUtils

<#
.SYNOPSIS
    Links the modules to $PSModulePath
.DESCRIPTION
    Creates symlinks for the modules to the $PSModulePath
.EXAMPLE
    . .\Link-Modules.ps1
#>

# Check to see if the script is running as administrator; exit if not
if (-Not (Test-IsElevated)) {
    Write-Error "Not in Administrator Mode!"
    return
}

# Paths
$SOURCE_PATH = "$PSScriptRoot\Modules"
$DESTINATION_PATH = "$HOME\Documents\PowerShell\Modules"

# Get all Modules
$Modules = Get-ChildItem -Path $SOURCE_PATH -Recurse | Where-Object {
    $_.Extension -eq ".psm1"
}

# Import Modules
$Modules | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$DESTINATION_PATH\$($_.BaseName)" -Target $_.DirectoryName -Force
}

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
