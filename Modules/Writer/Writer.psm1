# Import Helpers
Get-ChildItem -Path "$PSScriptRoot\Helpers" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force -Verbose
}

# ----------------
# Write-TypeWriter
# ----------------

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

    # Speed of the typewriter (150ms by default)
    [UInt32] $Speed = 150,

    # The minimum time for a keystroke (default: 10ms)
    [uint] $MinSpeed = 10
) {
    $Random = New-Object -TypeName System.Random
    $Text -split '' | ForEach-Object {
        $PauseFor = $MinSpeed + $Random.Next($Speed)
        $PauseFor *= if ($_ -eq ' ') { 5 } else { 1 }
        Start-Sleep -Milliseconds $($MinSpeed + $Random.Next($Speed))
        Write-Host -NoNewline $_
    }
    Write-NewLine
}
