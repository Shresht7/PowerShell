<#
.SYNOPSIS
    Sets file visibility in Windows
.DESCRIPTION
    This cmdlet changes the hidden attribute of files.
    It updates the registry to show or hide files.
.NOTES
    Invokes Explorer to refresh visibility after change
#>
function Set-FileVisibility {

    [CmdletBinding()]
    param(
        # Make files visible
        [Parameter(Mandatory, ParameterSetName = "Visible")]
        [switch] $Visible,

        # Make files hidden
        [Parameter(Mandatory, ParameterSetName = "Hidden")]
        [switch] $Hidden
    )

    $RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    if ($Visible) {
        Set-ItemProperty -Path $RegistryPath -Name Hidden -Value 1
    }
    if ($Hidden) {
        Set-ItemProperty -Path $RegistryPath -Name Hidden -Value 2
    }

    Invoke-ExplorerRefresh # refresh Explorer to reflect changes
}
