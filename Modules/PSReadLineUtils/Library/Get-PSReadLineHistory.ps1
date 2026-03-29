<#
.SYNOPSIS
    Returns the contents of the PSReadLine history file
.DESCRIPTION
    Returns the contents of the PSReadLine history file.
.EXAMPLE
    Get-PSReadLineHistory
    Returns the contents of the PSReadLine history file.
.EXAMPLE
    Get-PSReadLineHistory -Raw
    Returns the raw contents of the PSReadLine history file as an array of lines, without any processing or filtering.
#>
function Get-PSReadLineHistory {
    [CmdletBinding()]
    [OutputType([string[]])]
    param (
        # If specified, returns the raw contents of the history file as an array of lines, without any processing or filtering.
        [switch] $Raw,

        # If specified, only returns unique commands from the history file, removing any duplicates.
        [switch] $Unique
    )

    # If the -Raw switch is specified, return the raw contents of the history file as an array of lines
    if ($Raw) {
        return Get-Content -Path (Get-PSReadLineHistoryPath)
    }

    # Holds the unique commands we've seen so far, to filter out duplicates if -Unique is specified
    $seenCommands = [System.Collections.Generic.HashSet[string]]::new()

    # Buffer to accumulate lines of a command until we determine that the command is complete
    $commandBuffer = [System.Collections.ArrayList]@()

    # Read the history file line-by-line...
    foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineHistoryPath))) {
        # Add the line to the buffer
        $commandBuffer.Add($line) | Out-Null
        $command = $commandBuffer -join "`n"

        # If the command is complete, then output it and clear the buffer for the next command
        if (Test-CommandComplete $command) {
            $commandBuffer.Clear()

            # If the -Unique switch is specified, only return the command if we haven't seen it before. Otherwise, return all commands.
            if ($Unique) {
                if ($seenCommands.Add($command)) {
                    $command
                }
            }
            else {
                $command
            }
        }

        # If the command is not complete, then continue accumulating
    }
}

function Test-CommandComplete([string] $Command) {
    $tokens = $errors = $null

    # Tokenize the command and check for any parsing errors. If there are no errors, then the command is complete.
    [System.Management.Automation.PSParser]::Tokenize($Command, [ref] $tokens, [ref] $errors) | Out-Null

    if ($errors.Count -gt 0) {
        # has parsing errors, so might be incomplete OR just invalid.
        # We can check if the last error is an "Unexpected end of command" error, which indicates that the command is incomplete.
        $lastError = $errors[-1]
        if ($lastError.Message -match "Unexpected end of command") {
            return $false
        }

        # If the error is not an "Unexpected end of command" error, then the command is invalid,
        # but we can still consider it complete since it's not waiting for more input.
        return $true
    }

    # If there are no parsing errors, we can check the last token to see if it's an incomplete token.
    $lastToken = $tokens[-1]
    if (-not $lastToken) { return $true }

    $incompleteTypes = @(
        [System.Management.Automation.PSTokenType]::Operator
        [System.Management.Automation.PSTokenType]::GroupStart
        [System.Management.Automation.PSTokenType]::String
        [System.Management.Automation.PSTokenType]::Variable
    )

    if ($incompleteTypes -contains $lastToken.Type) {
        return $false
    }

    # If there are no parsing errors and the last token is not an incomplete token, then we can consider the command complete.
    return $true
}
