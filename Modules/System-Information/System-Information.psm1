# Import Library
if ($IsWindows) {
    Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object { . $_.FullName }
}
else {
    Write-Warning "This module is only supported on Windows operating system."
}
