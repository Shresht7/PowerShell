<#
.SYNOPSIS
    Get the paths of special folders on the system
.DESCRIPTION
    The `Get-SpecialFolders` function returns a list of objects that contain the names and paths of special folders
    on the system. Special folders are predefined system folders that are used to store specific types of files,
    such as the Desktop or the Start Menu.
.OUTPUTS
    System.Object
        An object that contains the name and path of each special folder on the system
.EXAMPLE
    Get-SpecialFolders
        Returns a list of objects that contain the names and paths of special folders on the system

#>
function Get-SpecialFolders() {
    $SpecialFolders = [System.Enum]::GetNames('System.Environment+SpecialFolder')

    foreach ($folder in $SpecialFolders) {
        [PSCustomObject]@{
            Name = $_
            Path = [System.Environment]::GetFolderPath($folder)
        }
    }
}
