<#
.SYNOPSIS
    Interactively select and invoke a script
.DESCRIPTION
    Shows a detailed listing of scripts and its preview in the given path (defaults to $HOME\Scripts)
    and allows you to chose a script to invoke.
.EXAMPLE
    Invoke-Script
    Opens the interactive selection in the default directory $HOME\Scripts
.EXAMPLE
    Invoke-Script .
    Opens the interactive selection in the current directory
.EXAMPLE
    Invoke-Script "bin" -Recurse
    Opens the interactive selection in the "bin" folder and look for scripts recursively
.NOTES
    Requires the PSFzf Module
#>
function Invoke-Script(
    [Alias("Directory", "Source", "SourcePath", "From")]
    [string] $Path = "$HOME\Scripts",

    # Look for scripts recursively
    [switch] $Recurse
) {
    # Get a list of all the scripts
    $Scripts = Get-ChildItem -Path $Path -Filter "*.ps1" -Recurse:$Recurse
    # Select a script to run
    $Script = $Scripts | Invoke-Fzf -FilepathWord -Preview "bat --style=numbers --color=always {}" -PreviewWindow "right:60%" -Height 100
    # Invoke the script
    . $Script
}

Set-Alias script Invoke-Script

Export-ModuleMember -Function Invoke-Script
Export-ModuleMember -Alias script
