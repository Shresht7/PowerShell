# Check to see if the script is running as administrator; exit if not
if (-Not (Test-IsElevated)) {
    Write-Error "Not in Administrator Mode!"
    return
}

# Get all Modules
$Modules = Get-ChildItem -Path "$PSScriptRoot\..\Modules" -Recurse | Where-Object {
    $_.Extension -eq ".psm1"
}

# Import Modules
$Modules | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\Modules\$($_.BaseName)" -Target $_.DirectoryName -Force -Verbose
}
