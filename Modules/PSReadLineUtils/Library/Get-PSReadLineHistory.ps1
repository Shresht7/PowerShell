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
        [switch] $Raw
    )

    # If the -Raw switch is specified, return the raw contents of the history file as an array of lines
    if ($Raw) {
        return Get-Content -Path (Get-PSReadLineHistoryPath)
    }

    $last = ''
    $lineBlock = [System.Collections.ArrayList]@()

    # Read the history file line by line
    foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineHistoryPath))) {

        # If the line ends with a backtick, it's a continuation of the previous line
        if ($line.EndsWith('`')) {
            # Remove the backtick and add the line to the lineBlock variable
            $line = $line.SubString(0, $line.Length - 1)
            $lineBlock.Add($line) | Out-Null
            continue
        }

        # If the line does not end with a backtick, but we have an existing lineBlock,
        # then add the line to the lineBlock and join the lines together with a newline
        # and reset the lineBlock variable
        if ($lineBlock) {
            $lineBlock.Add($line) | Out-Null
            $line = $lineBlock -join "`n"
            $lineBlock = @()
        }
    
        # If the line is not the same as the last line, add it to the history
        if ($line -ne $last) {
            $last = $line
            $line
        }
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
    if (-not $lastToken) { return $true } # No tokens means no command, so we can consider it complete (or at least not incomplete)

    # Check for common tokens that indicate an incomplete command, such as a pipe, a redirection operator, or an open parenthesis.
    $incompleteTokenKinds = @(
        [System.Management.Automation.PsTokenKind]::Pipe,
        [System.Management.Automation.PsTokenKind]::RedirectOut,
        [System.Management.Automation.PsTokenKind]::RedirectOutAppend,
        [System.Management.Automation.PsTokenKind]::RedirectIn,
        [System.Management.Automation.PsTokenKind]::RedirectInOut,
        [System.Management.Automation.PsTokenKind]::RedirectHereString,
        [System.Management.Automation.PsTokenKind]::RedirectHereStringIndented,
        [System.Management.Automation.PsTokenKind]::OpenParen
    )

    # If the last token is one of the incomplete token kinds, then we can consider the command incomplete.
    if ($incompleteTokenKinds -contains $lastToken.Kind) {
        return $false
    }

    # If there are no parsing errors and the last token is not an incomplete token, then we can consider the command complete.
    return $true
}
