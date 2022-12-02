<#
.SYNOPSIS
    Returns a list of special folders and their paths
.DESCRIPTION
    Returns a list of special folders and their paths
.EXAMPLE
    Get-SpecialFolders
    Returns a list of special folders and their paths
#>
function Get-SpecialFolders() {
    $SpecialFolders = [System.Enum]::GetNames('System.Environment+SpecialFolder')
    $SpecialFolders | ForEach-Object {
        [PSCustomObject]@{
            Name = $_
            Path = [System.Environment]::GetFolderPath($_)
        }
    }
}
