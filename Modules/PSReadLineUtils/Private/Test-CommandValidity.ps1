<#
.SYNOPSIS
    Tests the validity of a command or script.
.DESCRIPTION
    This function checks if a given command or script is valid using the PowerShell AST parser.
#>
function Test-CommandValidity {
    [CmdletBinding()]
    param (
        # The command or script to validate
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Name', 'Input', 'InputObject', 'Command')]
        [string] $Script,

        [switch] $WriteOutput
    )

    # If the script is empty or whitespace, return am empty array (nothing to validate)
    if ([string]::IsNullOrWhiteSpace($Script)) { return @() }

    # List of validation errors to return
    $Failures = @()

    # Parse the script into an AST (Abstract Syntax Tree)
    $Errors = $null
    $Tokens = $null
    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Script, [ref] $Tokens, [ref] $Errors)

    if ($Errors) {
        foreach ($ParseError in $Errors) {
            $Failures += [PSCustomObject] @{
                Message = $ParseError.Message
                Line    = $ParseError.Extent.StartLineNumber
                Column  = $ParseError.Extent.StartColumnNumber
            }
        }
    }

    # Find all the CommandAst Nodes in the AST (these represent command invocations. e.g. Get-ChildItem, git, Write-Output, etc.)
    $CommandNodes = $AST.FindAll({ param($ast) $ast -is [System.Management.Automation.Language.CommandAst] }, $true)
    foreach ($Node in $CommandNodes) {
        $CommandName = $Node.GetCommandName()
        if (-not $CommandName) { continue } # If we can't get a command name, skip validation for this node

        # Check if the command name is a valid command (cmdlet, function, alias, or executable)
        $CommandInfo = Get-Command $CommandName -ErrorAction SilentlyContinue
        if (-not $CommandInfo) {
            $Failures += [PSCustomObject] @{
                Message = "Unknown Command: $CommandName"
                Line    = $Node.Extent.StartLineNumber
                Column  = $Node.Extent.StartColumnNumber
            }   
            continue
        }

        # Skip parameter validation for external scripts and applications, since we can't validate parameters for those types of commands easily
        if ($CommandInfo.CommandType -eq 'ExternalScript' -or $CommandInfo.CommandType -eq 'Application') {
            # Note: For external scripts and applications, we can't validate parameters, so skip parameter validation
            continue
        }

        # If the command is an alias, resolve it to the actual command and validate parameters against the resolved commands
        if ($CommandInfo.CommandType -eq 'Alias') {
            $ResolvedCommand = Get-Command $CommandInfo.ResolvedCommandName -ErrorAction SilentlyContinue
            if ($ResolvedCommand) {
                $CommandInfo = $ResolvedCommand
            }
        }

        # Gather the parameters used in the command and compare them against the available parameters for the command.
        # If any parameters are used that are not in the available parameters for the command, add a failure for each unknown parameter.
        $UsedParameters = $Node.CommandElements | Where-Object { $_ -is [System.Management.Automation.Language.CommandParameterAst] }
        $AvailableParameters = $CommandInfo.Parameters.Keys
        foreach ($Param in $UsedParameters) {
            if ($AvailableParameters -notcontains $Param.ParameterName) {
                $Failures += [PSCustomObject] @{
                    Message = "Unknown Parameter: $($Param.ParameterName) for command $CommandName"
                    Line    = $Param.Extent.StartLineNumber
                    Column  = $Param.Extent.StartColumnNumber
                }
            }
        }
    }

    if ($WriteOutput) {
        if ($Failures.Count -eq 0) {
            Write-Host "VALID" -ForegroundColor Green
            return
        }

        # Write the script line and underline the position of each error with a caret (^) and write out the error below it
        foreach ($Failure in $Failures) {
            Write-Host ""
            $ScriptLines = $Script -split "`n"
            $ErrorLine = $ScriptLines[$Failure.Line - 1]
            Write-Host $ErrorLine
            Write-Host (' ' * ($Failure.Column - 1) + '^') -ForegroundColor Red
            Write-Host $Failure.Message -ForegroundColor Red
            Write-Host ""
        }
    }
    else {
        return $Failures
    }
}
