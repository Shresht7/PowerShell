# Requires-Modules Utilities, FSUtils

<#
.SYNOPSIS
    Symlinks modules from the local `Modules` folder to the `$PSModulePath`
.DESCRIPTION
    Creates symbolic links for each module from the local `Modules` folder to the `$PSModulePath`
.EXAMPLE
    . .\Link-Modules.ps1
#>

# Check to see if the script is running as administrator; exit if not
if (-Not (Test-IsElevated)) {
    Write-Error "Not in Administrator Mode! Elevated permissions are required to create Symbolic-Links"
    return
}

# Paths
$SOURCE_PATH = "$PSScriptRoot\Modules"
$DESTINATION_PATH = $Env:PSModulePath.Split(";")[0]

# Get all Modules
$Modules = Get-ChildItem -Path $SOURCE_PATH -Filter "*.psm1" -Recurse

# Import Modules
$Modules | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$DESTINATION_PATH\$($_.BaseName)" -Target $_.DirectoryName -Force
}

# Remove Broken Symlinks
Get-BrokenSymlink -Path $DESTINATION_PATH -Recurse | Remove-Item -Force
