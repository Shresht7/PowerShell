<#
.SYNOPSIS
    Play a particular sound
#>
function Invoke-SoundByte(
    # Name of the sound-byte to play
    [ArgumentCompleter({
            param ($cmd, $param, $wordToComplete)
            [array] $validValues = (Get-ChildItem -Path "$HOME\Music\Sound-Bytes" -File).Name
            return $validValues -like "*$wordToComplete*"
        })
    ]
    [string] $Name = (Get-ChildItem -Path $Script:SoundBytesPath -File | Invoke-Fzf)
) {
    # Imports
    Add-Type -AssemblyName presentationCore
    
    # Throw if $Name has not been specified
    if (!$Name) {
        throw "Please select a valid sound file"
    }

    # If $Name is not a valid path
    if (!(Test-Path -Path $Name)) {
        $Name = (Get-ChildItem -Path $Script:SoundBytesPath -File | Where-Object { $_.Name -eq $Name }).FullName
    }
    
    # Instantiate media player and load the file
    $mediaPlayer = New-Object system.windows.media.mediaplayer
    $mediaPlayer.open($Name)
    
    # Play the sound
    $mediaPlayer.Play()
}

