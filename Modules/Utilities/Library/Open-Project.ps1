
<#
.SYNOPSIS
    Opens a project in Visual Studio Code
.DESCRIPTION
    Opens a project in Visual Studio Code.
.EXAMPLE
    Open-Project -Path "C:\Projects\MyProject"
    Opens the project in Visual Studio Code.
#>
function Open-Project(
    # The path to the project to open
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path -Path $_ })]
    [Alias('Name')]
    [string] $Path,

    # The path to the projects directory
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $ProjectDirectory = "$HOME\Projects"
) {

    # Interactively select a project if none was provided
    if (-not $Path) {
        $Path = Get-ChildItem -Path $ProjectDirectory -Directory
        | Invoke-Fzf -Preview 'pwsh -NoProfile -Command if (Test-Path -Path {}\README.md) { bat --style=numbers --color=always {}\README.md } else { Get-ChildItem -Path {} }' -Height "100%" -PreviewWindow "right:60%"
    }

    # Open the selected project in VS Code
    if ($Path) {
        code $Path
    }

}

Export-ModuleMember -Function Open-Project
