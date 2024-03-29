<#
.SYNOPSIS
    Invoke an npm script
.DESCRIPTION
    Invoke an npm script from a package.json file
.EXAMPLE
    Invoke-NpmScript
    Invoke an npm script from the package.json file in the current directory
.EXAMPLE
    Invoke-NpmScript -Path "C:\Projects\MyProject"
    Invoke an npm script from the package.json file in the given directory
#>
function Invoke-NpmScript(
    # Name of the npm script to invoke
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [string] $Name,

    # Path to the package.json file
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path = $PWD.Path
) {
    # Get the list of npm scripts
    $Scripts = Get-NpmScript -Path $Path

    # If the name is not specified, then use Fzf to select the script
    $Delimiter = ": "
    $FzfOptions = @{
        Delimiter = $Delimiter
        Prompt    = "npm run "
        Header    = "Select an npm script to run`n"
        Ansi      = $true
    }
    if (-Not $Name) {
        $Name = $Scripts |
        ForEach-Object { $_.Name + $Delimiter + $PSStyle.Foreground.BrightBlack + $_.Script + $PSStyle.Reset } |
        Invoke-Fzf @FzfOptions
        
        $Name = $Name -split $Delimiter | Select-Object -First 1
    }

    # Get the script
    $Script = $Scripts | Where-Object { $_.Name -eq $Name }

    # Exit if the script is not found
    if (-Not $Script) { return }

    # Invoke the npm script
    npm run $Script.Name
}
