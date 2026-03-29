<#
.SYNOPSIS
    Checks if a specified path is included in the PATH environment variable
.DESCRIPTION
    Checks if a specified path is included in the PATH environment variable, splitting the PATH variable on
    the appropriate delimiter for the operating system and trimming whitespace.
.EXAMPLE
    Test-InEnvPath -Path "C:\Windows\System32"
    Checks if "C:\Windows\System32" is included in the PATH environment variable and returns true or false.
.EXAMPLE
    Test-InEnvPath
    Checks if the current directory (PWD) is included in the PATH environment variable and returns true or false.
#>
function Test-InEnvPath([string] $Path = ($PWD.Path)) {
    # Determine the appropriate delimiter for splitting the PATH variable based on the operating system
    $Delimiter = if ($IsWindows) { ';' } else { ':' }

    # Normalize the path
    $Path = $Path.Trim().TrimEnd('\', '/')

    # Check if the path is in the PATH environment variable
    $envPaths = $env:PATH -split $Delimiter | ForEach-Object { $_.Trim().TrimEnd('\', '/') } | Where-Object { $_ -ne "" }

    # Return true if the specified path is in the PATH environment variable, false otherwise
    return $envPaths -contains $Path
}
