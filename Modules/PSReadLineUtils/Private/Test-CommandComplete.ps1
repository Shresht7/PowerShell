<#
.SYNOPSIS
    Tests if a command is complete or incomplete.
.DESCRIPTION
    Uses the PowerShell AST parser to determine if a command is complete or if it's waiting
    for more input. This leverages the IncompleteInput property on parse errors, which is the
    same mechanism PSReadLine itself uses to decide whether to execute or continue a multi-line
    command.
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
    $tokens = $null
    $errors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseInput($Command, [ref]$tokens, [ref]$errors)

    # If any parse error indicates incomplete input, the command is not yet complete
    foreach ($err in $errors) {
        if ($err.IncompleteInput) {
            return $false
        }
    }

    return $true
}
