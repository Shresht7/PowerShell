<#
.SYNOPSIS
    TODO:
.DESCRIPTION
    TODO:
#>

[CmdletBinding()]
param(
    # The type of the conventional commit
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [ValidateSet('feat', 'fix', 'docs', 'style', 'refactor')]
    [string] $Type,

    # (Optional) The scope of the commit
    [string] $Scope,

    # The commit message describing the subject of the change
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [Alias('Commit', 'CommitMessage', 'Subject', 'Summary')]
    [string] $Message,

    # The description of the change
    [Parameter(Position = 2)]
    [Alias('Body')]
    [string] $Description
)

# TODO: Add the remaining conventional commit types
$CONVENTIONAL_COMMIT_TYPES = @(
    'feat'
    'fix'
    'docs'
    'style'
    'refactor'
)

# Prompt the user for the commit type, if not provided already
if (-not $Type) {
    $Type = $CONVENTIONAL_COMMIT_TYPES | Invoke-Fzf
}

# Prompt the user for the commit scope
if (-not $Scope) {
    $Scope = Read-Host -Prompt "Scope (Optional)"
    if (-not $Scope) {
        $Scope = ""
    }
    else {
        $Scope = "($Scope)"
    }
}

# Prompt the user for the commit message
if (-not $Message) {
    $Message = Read-Host -Prompt "Commit Message"
}

# Prompt the user for additional information
if (-not $Description) {
    $Description = Read-Host -Prompt "Description (Optional)"
    if (-not $Description) {
        $Description = ""
    }
    else {
        $Description = "`n`n" + $Description
    }
}

# Assemble the commit message
$COMMIT = $Type + $Scope + ": " + $Message + $Description

# Output the commit message
Write-Output $COMMIT
