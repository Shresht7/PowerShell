<#
.SYNOPSIS
    Write text like a typewriter
.DESCRIPTION
    Writes the given text like a typewriter would
#>
function Write-TypeWriter(
    # The text to write
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Text,

    # Speed of the typewriter (250ms by default)
    [UInt32] $Speed = 150
) {
    $Random = New-Object -TypeName System.Random
    $Text -split '' | ForEach-Object {
        $PauseFor = 1 + $Random.Next($Speed)
        $PauseFor *= if ($_ -eq ' ') { 5 } else { 1 }
        Start-Sleep -Milliseconds $(1 + $Random.Next($Speed))
        Write-Host -NoNewline $_
    }
}
