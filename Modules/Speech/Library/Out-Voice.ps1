<#
.SYNOPSIS
    Speak out the given text.
.DESCRIPTION
    Uses text-to-speech to speak out the provided text.
.EXAMPLE
    Out-Voice -Text "Good Morning!"
    Speaks "Good Morning!"
.EXAMPLE
    Out-Voice -Text "Fast and loud" -Rate 5 -Volume 100
    Speaks text at a higher speed and maximum volume.
.EXAMPLE
    Get-Date | Out-Voice
    Can accept input from the pipeline. Speaks the current date.
.PARAMETER Text
    The text to speak out.
.PARAMETER VoiceId
    The ID of the voice to use. If not specified, the system's default voice is used.
.PARAMETER Rate
    The speed of the speech (Range: -10 to 10).
.PARAMETER Volume
    The volume of the speech (Range: 0 to 100).
#>
function Out-Voice {
    [CmdletBinding()]
    param(
        # The text to speak out
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Text,

        # The ID of the voice to use
        [string] $VoiceId,

        # The speed of the speech (-10 to 10)
        [ValidateRange(-10, 10)]
        [int] $Rate = 0,

        # The volume of the speech (0 to 100)
        [ValidateRange(0, 100)]
        [int] $Volume = 100
    )

    process {
        Add-Type -AssemblyName System.Speech
        $Synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
        
        # Configure Rate and Volume
        $Synthesizer.Rate = $Rate
        $Synthesizer.Volume = $Volume

        # Select a voice if VoiceId is provided
        if (-not [string]::IsNullOrWhiteSpace($VoiceId)) {
            try {
                $Synthesizer.SelectVoice($VoiceId)
            }
            catch {
                Write-Warning "Voice ID '$VoiceId' not found. Using system default voice."
            }
        }

        # Speak the text
        $Synthesizer.Speak($Text)
    }
}
