<#
.SYNOPSIS
    Write a conventional commit message
.DESCRIPTION
    Write a conventional commit message.
.LINK
    https://www.conventionalcommits.org/en/v1.0.0/
#>

[CmdletBinding()]
param (
    # The type of the conventional commit
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [ValidateSet('build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf', 'refactor', 'revert', 'style', 'test')]
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

# List of valid types
$CONVENTIONAL_COMMIT_TYPES = @(
    'build'
    'chore'
    'ci'
    'docs'
    'feat'
    'fix'
    'perf'
    'refactor'
    'revert'
    'style'
    'test'
)

# Prompt the user for the commit type, if not provided already
if (-not $Type) {
    $Type = $CONVENTIONAL_COMMIT_TYPES | Invoke-Fzf
}
Write-Host -Object "Type: $($PSStyle.Foreground.Red)$Type$($PSStyle.Reset)"

# Prompt the user for the commit scope
if (-not $Scope) {
    $Scope = Read-Host -Prompt "Scope $($PSStyle.Foreground.BrightBlack)(Optional)$($PSStyle.Reset)"
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

# Draw the separator
Write-Host -Object ("-" * $Host.UI.RawUI.WindowSize.Width)

# Assemble the commit message
$COMMIT = $Type + $Scope + ": " + $Message + $Description

# Output the commit message
Write-Output $COMMIT
