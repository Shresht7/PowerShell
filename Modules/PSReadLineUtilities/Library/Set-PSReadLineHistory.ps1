<#
.SYNOPSIS
    Set the PSReadLine history contents
.DESCRIPTION
    Sets (overwrites) the contents of the PSReadLine history file. Useful after performing
    some manipulation on the existing history (using Get-PSReadLineHistory)
.EXAMPLE
    Set-PSReadLineHistory ($Content)
    Updates the PSReadLineHistory Contents with $Contents
#>
function Set-PSReadLineHistory(
    # The new contents of the PSReadLine history file
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Content
) {
    $Path = Get-PSReadLineHistoryPath
    $Temp = "$Path.temp"
    $Content | Out-File $Temp
    Move-Item -Path $Temp -Destination $Path -Force
}
