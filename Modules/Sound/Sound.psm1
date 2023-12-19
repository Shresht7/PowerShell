# Script Variables
$Script:SoundBytesPath = "$HOME\Music\Sound-Bytes"

# Import Library
Get-ChildItem -Path "$PSScriptRoot\Library" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
    Export-ModuleMember -Function $_.BaseName
}
