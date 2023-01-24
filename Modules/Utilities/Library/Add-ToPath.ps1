<#
.SYNOPSIS
    Add the path to the PATH environment variable.
.DESCRIPTION
    Adds the path to the PATH environment variable.
    This is useful for adding executables to the PATH.
.EXAMPLE
    Add-ToPath -Path "C:\Program Files\Git\bin"
    Adds the Git bin directory to the PATH environment variable.
#>
function Add-ToPath(
    # The path to add to the PATH environment variable.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Source", "SourcePath", "From")]
    [string] $Path
) {
    $Path = Get-Item -Path $Path
    $Env:Path += ";$($Path.DirectoryName)"
}
