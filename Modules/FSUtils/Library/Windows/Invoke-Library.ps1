<#
.SYNOPSIS
    Opens the library folder
.DESCRIPTION
    Calls `Invoke-Item` on the library folder, opening it in the file-explorer
.EXAMPLE
    Invoke-Library -Name Pictures
    Opens the `Pictures` library folder
.EXAMPLE
    Get-Library | Invoke-Fzf | Invoke-Library
    Interactively choose the library folder to open
    (Note: This example requires the `PSFzf` module)
#>
function Invoke-Library(
    # Name of the library to open
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Name
) {
    # Select the library to open
    $Library = Get-Library | Where-Object { $_.FullName -like "*$Name*" } | Select-Object -First 1
    if ([string]::IsNullOrEmpty($Library)) { return }
    # Invoke the library folder. Opens it in the file-explorer
    Invoke-Item -Path $Library
}
