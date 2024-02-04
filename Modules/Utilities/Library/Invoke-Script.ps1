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
    Invoke-Script -Path "Write-CommitMessage.ps1"
    Invokes the script "Write-CommitMessage.ps1" directly
.EXAMPLE
    Invoke-Script -Path "bin" -Recurse
    Opens the interactive selection in the "bin" folder and look for scripts recursively
.NOTES
    Requires the PSFzf Module and the fzf utility
#>
function Invoke-Script(
    # Path to the script or the folder containing the scripts
    [Alias("Name", "FullName", "Source", "SourcePath", "From")]
    [string] $Path = "$HOME\Scripts",

    # Query to filter the scripts
    [Alias("Filter", "Search")]
    [string] $Query,

    # Look for scripts recursively
    [switch] $Recurse
) {
    # Get the given item
    $Item = Get-Item -Path $Path

    # If the $Path is a PowerShell script, then invoke it directly
    if ($Item.Extension -eq ".ps1") {
        . $Item.FullName
    }

    # Else if the $Path is a directory, then Invoke-PSFzf
    if ($Item.PSIsContainer) {

        # Get a list of all the scripts
        $Scripts = Get-ChildItem -Path $Path -Recurse:$Recurse

        # Set Options for Fzf
        $FzfOptions = @{
            Preview       = "bat --style=numbers --color=always {}"
            PreviewWindow = "right:60%"
            Height        = 100
            Prompt        = ". "
            Header        = "Select a script to run`n`n"
            Query         = $Query
        }

        # Select a script to run
        $Script = $Scripts | Invoke-Fzf @FzfOptions

        # Return early if no script was selected
        if (-not $Script) { return }

        # Invoke the script if it was selected
        if ($Script.EndsWith(".ps1")) {
            . $Script
        }
        elseif ($Script.EndsWith(".js")) {
            node $Script
        }

    }
    
}

Set-Alias script Invoke-Script

Export-ModuleMember -Function Invoke-Script
Export-ModuleMember -Alias script
