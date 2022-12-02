<#
.SYNOPSIS
    Lists installed text-to-speech voices
.DESCRIPTION
    Returns a list of installed text-to-speech (TTS) voices
.EXAMPLE
Get-Voice
Lists all installed text-to-speech voices
#>
function Get-Voice {
    Add-Type -AssemblyName System.Speech
    $Synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

    $Synthesizer.GetInstalledVoices().VoiceInfo
}
