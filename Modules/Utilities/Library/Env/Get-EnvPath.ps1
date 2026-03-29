<#
.SYNOPSIS
    Returns the individual paths from the PATH environment variable as an array of strings
.DESCRIPTION
    Returns the individual paths from the PATH environment variable as an array of strings,
    splitting on the appropriate delimiter for the operating system and trimming whitespace.
.EXAMPLE
    Get-EnvPath
    Returns the individual paths from the PATH environment variable as an array of strings.
#>
function Get-EnvPath {
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    # Determine the appropriate delimiter for splitting the PATH variable based on the operating system
    $Delimiter = if ($IsWindows) { ';' } else { ':' }

    # Split the PATH environment variable using the determined delimiter, trim whitespace, and filter out any empty entries
    $Env:Path -split $Delimiter | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
}
