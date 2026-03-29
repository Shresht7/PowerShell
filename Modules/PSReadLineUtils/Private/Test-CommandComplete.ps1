<#
.SYNOPSIS
    Tests if a command is complete or incomplete.
.DESCRIPTION
    Uses the PowerShell parser to determine if a command is complete or if it's waiting for more input. This is useful for correctly handling multi-line commands in the PSReadLine history, since a
command is not necessarily complete just because it has a newline in it - it could be a multi-line command that is still waiting for more input.
.EXAMPLE
    Test-CommandComplete "Get-Process"
    Returns $true, since "Get-Process" is a complete command.
.EXAMPLE
    Test-CommandComplete "Get-Process |"
    Returns $false, since the pipe operator indicates that the command is waiting for more input.
.EXAMPLE
    Test-CommandComplete '"hello'
    Returns $false, since the unclosed string indicates that the command is waiting for more input.
.EXAMPLE
    Test-CommandComplete "(Get-Process"
    Returns $false, since the unclosed parenthesis indicates that the command is waiting for more input.
.OUTPUTS
    [bool] $true if the command is complete, or $false if the command is incomplete and waiting for more input.
#>
function Test-CommandComplete([string] $Command) {
    $errors = [System.Collections.ObjectModel.Collection[System.Management.Automation.PSParseError]]::new()
    $tokens = [System.Management.Automation.PSParser]::Tokenize($Command, [ref]$errors)

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
