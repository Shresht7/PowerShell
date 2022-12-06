<#
.SYNOPSIS
Find the path of the given program's executable
.DESCRIPTION
Locates the path for the given program's executable like the Unix `which` command.
.EXAMPLE
Find-Path git
Returns C:\Program Files\Git\cmd\git.exe
#>
function Find-Path(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Executable", "Path")]
    [string] $Command
) {
    Get-Command -Name $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

Set-Alias which Find-Path
