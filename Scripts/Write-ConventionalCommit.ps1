<#
.SYNOPSIS
    Write a conventional commit message
.DESCRIPTION
    This script prompts the user for the type, scope, message, and description of a conventional commit and outputs the formatted commit message.
.EXAMPLE
    PS> Write-ConventionalCommit
    Type: feat
    Scope (Optional): my-module
    Commit Message: Add new feature to my module
    Description (Optional): This feature allows users to do X, Y, and Z.
    Output: feat(my-module): Add new feature to my module

    If the user provides a description, it will be included in the output as well:
        feat(my-module): Add new feature to my module

        This feature allows users to do X, Y, and Z.
.LINK
    https://www.conventionalcommits.org
#>

[CmdletBinding()]
param (
    # The type of the conventional commit (e.g., feat, fix, docs, etc.)
    [ValidateSet('build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf', 'refactor', 'revert', 'style', 'test')]
    [string] $Type,

    # (Optional) The scope of the commit (e.g., the name of the package or module being changed)
    [string] $Scope,

    # The commit message describing the subject of the change (e.g., "Add new feature", "Fix bug in module", etc.)
    [Alias('Commit', 'CommitMessage', 'Subject', 'Summary', 'Title')]
    [string] $Message,

    # The description of the change (e.g., a more detailed explanation of the change, why it was made, etc.)
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
    $Type = if (Get-Command -Name Select-Fuzzy -ErrorAction SilentlyContinue) {
        $CONVENTIONAL_COMMIT_TYPES | Select-Fuzzy
    }
    else {
        Read-Host -Prompt "Type (e.g., feat, fix, docs, etc.)"
    }
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
