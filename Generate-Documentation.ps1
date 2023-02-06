# Requires-Modules platyps

<#
.SYNOPSIS
    Generate documentation for PowerShell modules
.DESCRIPTION
    This script generates documentation for PowerShell modules using platyps.
.PARAMETER Source
    The source directory containing the modules.
    Default: Modules
.PARAMETER Filter
    The filter to use when searching for modules.
    Default: *.psd1
.PARAMETER Recurse
    Recurse into subdirectories.
    Default: False
.PARAMETER OutputFolder
    The output directory for the documentation files.
    If the output directory is an absolute path, it will be used as-is. Otherwise, it will be relative to the module's directory.
    Default: Docs
.EXAMPLE
    Generate-Documentation.ps1
.EXAMPLE
    Generate-Documentation.ps1 -Source "C:\Modules"
.EXAMPLE
    Generate-Documentation.ps1 -Source "C:\Modules" -Filter "*.psd1" -Recurse"
.EXAMPLE
    Generate-Documentation.ps1 -Source "C:\Modules" -Filter "*.psd1" -Recurse -OutputFolder "C:\Docs"
#>
Param (
    # The source directory containing the modules
    [Alias('Path', 'Directory', 'Folder', 'Root', 'SourcePath')]
    [ValidateScript({ Test-Path -Path $_ -PathType Container })]
    [ValidateNotNullOrEmpty()]
    [string[]] $Source = (Join-Path -Path $PSScriptRoot -ChildPath Modules),

    # The filter to use when searching for modules
    [Alias('FileFilter', 'FilePattern', 'Pattern')]
    [string] $Filter = "*.psd1",

    # Recurse into subdirectories
    [Alias('RecurseSubdirectories')]
    [switch] $Recurse,
  
    # The output directory for the documentation files
    [Alias('Destination', 'DestinationPath', 'OutputPath')]
    [string] $OutputFolder = "Docs"
)

Begin {
    # Get a list of all the modules with a manifest
    $Modules = Get-ChildItem -Path $Source -Filter:$Filter -Recurse

    # Create the progress bar
    $ProgressBarActivity = "Generating documentation"
    Write-Progress -Activity $ProgressBarActivity -Status "Initializing" -PercentComplete 0

    # Write a message to the console
    Write-Verbose -Message "Generating documentation for $($Modules.Count) modules..."
}

Process {
    # Generate the documentation for each module
    $Modules | ForEach-Object {
        Write-Progress -Activity $ProgressBarActivity `
            -Status "Generating documentation for module: $($_.BaseName)" `
            -PercentComplete ($Modules.IndexOf($_) / $Modules.Count * 100)
    
        # Import the module
        Import-Module -Name $_.BaseName -Force
    
        # Create the output directory
        # If the output folder is relative, then it is relative to the module's directory,
        # otherwise treat it is as an absolute path
        if ($OutputFolder -match "^[A-Za-z]:") {
            $Destination = $OutputFolder
        }
        else {
            $Destination = Join-Path -Path $_.DirectoryName -ChildPath $OutputFolder
        }
        
        # Generate the documentation
        $MarkdownHelpOptions = @{
            AlphabeticParamsOrder = $true
            Force                 = $true
            OutputFolder          = $Destination
            WithModulePage        = $true        
        }
        New-MarkdownHelp -Module $_.BaseName @MarkdownHelpOptions
    }
}

End {
    # Remove the progress bar
    Write-Progress -Activity $ProgressBarActivity -Completed
}
