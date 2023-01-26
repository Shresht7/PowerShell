
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
    [Alias('Name')]
    [string] $Path,

    # The path to the projects directory
    [string] $ProjectDirectory = "$HOME\Projects",

    # The preview command
    [string] $PreviewCommand = 'bat --style=numbers --color=always {}\README.md'


) {
    # Interactively select a project if none was provided
    if (-not $Path) {
        $Path = Get-ChildItem -Path $ProjectDirectory -Directory
        | Invoke-Fzf -Preview $PreviewCommand -Height "100%" -PreviewWindow "right:60%"
    }

    # Open the selected project in VS Code
    if ($Path) {
        code $Path
    }
}

Export-ModuleMember -Function Open-Project
