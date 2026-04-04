<#
.SYNOPSIS
    Find the path of the given program's executable
.DESCRIPTION
    Locates the path for the given program's executable like the Unix `which` command.
.EXAMPLE
    Find-Path git
    Returns C:\Program Files\Git\cmd\git.exe
.EXAMPLE
    Find-Path git -Directory
    Returns C:\Program Files\Git\cmd
.EXAMPLE
    which node
    Returns C:\Program Files\nodejs\node.exe
.EXAMPLE
    which -dir node
    Returns C:\Program Files\nodejs
#>
function Find-Path(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Executable", "Path")]
    [string] $Command,

    [Alias("Dir", "Folder", "Base")]
    [switch] $Directory
) {
    $FoundPath = Get-Command -Name $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue

    if ($Directory) {
        return $FoundPath | Split-Path
    }

    $FoundPath
}

Set-Alias -Name which -Value Find-Path -Scope Global
