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
    [string] $VoiceId = "*TTS_MS_EN-US_ZIRA_11.0"
) {
    $TTS = New-Object -ComObject SAPI.SPVoice
    $TTS.Voice = $TTS.GetVoices() | Where-Object { $_.Id -like $VoiceId }
    $null = $TTS.Speak($Text)
    return $Text
}
