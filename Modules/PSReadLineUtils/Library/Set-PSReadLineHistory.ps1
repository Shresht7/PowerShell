<#
.SYNOPSIS
    Set the PSReadLine history contents
.DESCRIPTION
    Sets (overwrites) the contents of the PSReadLine history file. Useful after performing
    some manipulation on the existing history (using Get-PSReadLineHistory)
.EXAMPLE
    Set-PSReadLineHistory -Content ($Content)
    Updates the PSReadLineHistory Contents with $Contents
.EXAMPLE
    Set-PSReadLineHistory -Content (Get-PSReadLineHistory | Where-Object { $_ -notmatch "Get-Service" })
    Removes all instances of the "Get-Service" command from the PSReadLine history.
#>
function Set-PSReadLineHistory(
    # The new contents of the PSReadLine history file
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Content
) {
    # Check if $Content is valid
    if ($null -eq $Content || $Content -eq "") {
        throw "The Content parameter is required."
    }

    $Path = Get-PSReadLineHistoryPath
    $Temp = "$Path.temp"
    $Content | Out-File -FilePath $Temp
    Move-Item -Path $Temp -Destination $Path -Force
}
