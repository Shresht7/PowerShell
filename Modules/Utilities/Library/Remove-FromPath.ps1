<#
.SYNOPSIS
    Remove the path from the PATH environment variable.
.DESCRIPTION
    Removes the path from the PATH environment variable.
    This is useful for removing executables from the PATH.
.EXAMPLE
    Remove-FromPath -Path "C:\Program Files\Git\bin"
    Removes the Git bin directory from the PATH environment variable.
#>
function Remove-FromPath(
    [string] $Path
) {
    $Path = Get-Item -Path $Path
    $Env:Path = $Env:Path -replace ";$($Path.DirectoryName)", ""
}
