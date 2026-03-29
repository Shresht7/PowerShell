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
    param (
        # The scope of the environment variable to retrieve. Can be 'Process', 'User', or 'Machine'. Defaults to 'Process'.
        [ValidateSet("Process", "User", "Machine")]
        [string]$Scope = "Process"
    )

    # Determine the appropriate delimiter for splitting the PATH variable based on the operating system
    $Delimiter = if ($IsWindows) { ';' } else { ':' }

    # Get PATH based on the specified scope
    $Path = switch ($Scope) {
        "Process" { $Env:Path }
        "User" { if ($IsWindows) { [Environment]::GetEnvironmentVariable("Path", "User") } else { $Env:Path } }
        "Machine" { if ($IsWindows) { [Environment]::GetEnvironmentVariable("Path", "Machine") } else { $Env:Path } }
    }

    # Split the PATH environment variable using the determined delimiter, trim whitespace, and filter out any empty entries
    $Path -split $Delimiter | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}
