<#
.SYNOPSIS
    Returns the contents of the PSReadLine history file
.DESCRIPTION
    Returns the contents of the PSReadLine history file as a collection of commands.
    Multi-line commands are correctly reassembled using the backtick continuation
    format that PSReadLine uses to store them.
.EXAMPLE
    Get-PSReadLineHistory
    Returns the contents of the PSReadLine history file.
.EXAMPLE
    Get-PSReadLineHistory -Raw
    Returns the raw contents of the PSReadLine history file as a single string, without any processing or filtering.
.EXAMPLE
    Get-PSReadLineHistory -Unique
    Returns only unique commands from the history file.
.EXAMPLE
    Get-PSReadLineHistory | fzf
    Pipe history into fzf for fuzzy selection (multi-line commands display correctly).
#>
function Get-PSReadLineHistory {
    [CmdletBinding()]
    [OutputType([string[]])]
    param (
        # If specified, returns the raw contents of the history file as a single string, without any processing or filtering.
        [switch] $Raw,

        # If specified, only returns commands that contain the given filter string. 
        [string] $Filter,

        # If specified, only returns unique commands from the history file, removing any duplicates.
        [switch] $Unique
    )
    
    # If the -Raw switch is specified, return the raw contents of the history file as a single string
    if ($Raw) {
        return Get-Content -Path (Get-PSReadLineHistoryPath) -Raw
    }

    # Holds the unique commands we've seen so far, to filter out duplicates if -Unique is specified
    $seenCommands = [System.Collections.Generic.HashSet[string]]::new()

    # StringBuilder to accumulate lines of a multi-line command
    $buffer = [System.Text.StringBuilder]::new()

    # Read the history file line-by-line, using PSReadLine's backtick continuation format:
    # - Lines ending with a backtick (`) are continuation lines; the backtick is stripped
    #   and the line is joined with a newline to form a multi-line command.
    # - Lines NOT ending with a backtick mark the end of a command.
    try {
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineHistoryPath))) {
            if ($line.EndsWith('`')) {
                # Continuation line: strip trailing backtick, append with newline
                $buffer.Append($line, 0, $line.Length - 1) | Out-Null
                $buffer.Append("`n") | Out-Null
                continue
            }

            # End of command: append last line and emit
            $buffer.Append($line) | Out-Null
            $command = $buffer.ToString()
            $buffer.Clear() | Out-Null

            $shouldOutput = $true

            # If a filter is specified, check if the command contains the filter string
            if ($Filter -and $command -notlike "*$Filter*") {
                $shouldOutput = $false
            }

            # If -Unique is specified, check if we've already seen this command before
            if ($Unique -and -not $seenCommands.Add($command)) {
                $shouldOutput = $false
            }

            if ($shouldOutput) {
                $command
            }
        }

        # If there's leftover content in the buffer (file ended mid-command), emit it as-is
        if ($buffer.Length -gt 0) {
            $command = $buffer.ToString()
            $shouldOutput = $true
            if ($Filter -and $command -notlike "*$Filter*") { $shouldOutput = $false }
            if ($Unique -and -not $seenCommands.Add($command)) { $shouldOutput = $false }
            if ($shouldOutput) { $command }
        }
    }
    catch {
        throw "Failed to process PSReadLine history file. $_"
    }
}
