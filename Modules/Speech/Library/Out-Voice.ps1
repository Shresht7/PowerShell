<#
.SYNOPSIS
    Speak out the given text
.DESCRIPTION
    Uses text-to-speech to speak out the provided text
.EXAMPLE
    Out-Voice -Text "Good Morning!"
    Speaks "Good Morning!"
.EXAMPLE
    Get-Date | Out-Voice
    Can accept input from the pipeline. Speaks the current date
#>
function Out-Voice(
    # The text to speak out
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Text,

    # The ID of the voice to use
    [string] $VoiceId = "MSTTS_V110_enUS_ZiraM"
) {
    Add-Type -AssemblyName System.Speech
    $Synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $Synthesizer.SelectVoice($VoiceId)
    $Synthesizer.Speak($Text)
}
