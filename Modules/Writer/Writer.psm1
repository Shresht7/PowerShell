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

    # Characters per minute
    [uint] $CPM = 350,

    # Speed of the typewriter (150ms by default)
    [uint] $Speed = 150,

    # The minimum time for a keystroke (default: 10ms)
    [uint] $MinSpeed = 10,

    # The list of characters to pause at
    [string[]] $PauseAt = @(" ", "`n"),

    # The the multiplier to apply when pausing
    [ValidatePattern("[0-9]+")]
    [uint] $PauseMultiplier = 3
) {

    # Calculate the speed based on the given CPM (Characters-Per-Minute) if specified
    if ($CPM) {
        $Speed = (60 * 1000) / $CPM
    }

    # Instantiate the Random Object
    $Random = New-Object -TypeName System.Random

    $Text -split '' | ForEach-Object {
        # Determine the duration to pause for
        $PauseFor = $MinSpeed + $Random.Next($Speed)
        # Apply pause multiplier if the character belongs to the $PauseAt set
        if ($PauseAt -contains $_) {
            $PauseFor *= $PauseMultiplier
        }
    
        # Write the character to the screen
        Write-Host -NoNewline $_

        # Pause for the duration
        Start-Sleep -Milliseconds $PauseFor
    }

    # Write empty newline at the end
    Write-NewLine
}
