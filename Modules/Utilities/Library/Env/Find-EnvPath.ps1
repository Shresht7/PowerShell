<#
.SYNOPSIS
    Finds paths in the PATH environment variable that match a specified pattern or are duplicated.
.DESCRIPTION
    Finds paths in the PATH environment variable that match a specified pattern or are duplicated.
.EXAMPLE
    Find-EnvPath -Like git
    Returns paths in the PATH environment variable that contain "git".
.EXAMPLE
    Find-EnvPath -Duplicates
    Returns paths in the PATH environment variable that are duplicated, along with their counts.
#>
function Find-EnvPath {
    [CmdletBinding(DefaultParameterSetName = "Path")]
    param (
        # The path to check if it is in the PATH environment variable.
        [Parameter(ParameterSetName = "Path", ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Name", "FullName", "Path")]
        [string] $Like,

        # If specified, only returns the paths that are duplicated in the PATH environment variable.
        [Parameter(ParameterSetName = "Duplicates")]
        [switch] $Duplicates
    )

    # Determine the appropriate delimiter for splitting the PATH variable based on the operating system
    $Delimiter = if ($IsWindows) { ';' } else { ':' }

    # Check if the path is in the PATH environment variable
    $envPaths = $env:PATH -split $Delimiter | ForEach-Object { $_.Trim().TrimEnd('\', '/') } | Where-Object { $_ -ne "" }

    if ($Duplicates) {
        # Return only the paths that are duplicated in the PATH environment variable
        $envPaths | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -Property Count, Name
    }
    else {
        # Return all paths in the PATH environment variable
        $envPaths | Where-Object { $_ -like "*$Like*" }
    }
}
