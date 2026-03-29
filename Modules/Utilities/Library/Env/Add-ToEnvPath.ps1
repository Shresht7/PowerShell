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
function Add-ToEnvPath(
    # The path to add to the PATH environment variable.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name", "Source", "SourcePath", "From")]
    [string] $Path
) {
    $Path = Get-Item -Path $Path
    $DirectoryPath = if ($Path.PSIsContainer) { $Path.FullName } else { $Path.DirectoryName }
    $Delimiter = if ($IsWindows) { ';' } else { ':' }
    $Env:Path += "$Delimiter" + "$DirectoryPath"
}
