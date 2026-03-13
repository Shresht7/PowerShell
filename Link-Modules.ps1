<#
.SYNOPSIS
    Symlinks modules from the local `Modules` folder to the `$PSModulePath`
.DESCRIPTION
    Creates symbolic links for each module from the local `Modules` folder to the `$PSModulePath`
.EXAMPLE
    . .\Link-Modules.ps1
#>

# Source Path
$SOURCE_PATH = "$PSScriptRoot\Modules"

# Windows and Linux have different delimters apparently
$Delimiter = if ($PSVersionTable.OS -like "*Windows*") { ";" } else { ":" }

# Destination Path
$DESTINATION_PATH = $Env:PSModulePath.Split($Delimiter)[0]

# Get all Modules
$Modules = Get-ChildItem -Path $SOURCE_PATH -Filter "*.psm1" -Recurse

# Import Modules
$Modules | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$DESTINATION_PATH\$($_.BaseName)" -Target $_.DirectoryName -Force
}

# Remove Broken Symlinks
Get-ChildItem -Path $DESTINATION_PATH -Recurse |
Where-Object { $_.LinkType -eq "SymbolicLink" -and -not (Test-Path -Path $_.LinkTarget) } |
Remove-Item -Force
