# Import Library
if ($IsWindows) {
    Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object { . $_.FullName }
}
else {
    Write-Warning "The Speech module currently only supports Windows."
}
