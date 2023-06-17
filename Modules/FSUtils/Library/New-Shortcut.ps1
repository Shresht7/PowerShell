<#
    .SYNOPSIS
    Creates a new shortcut
    .DESCRIPTION
    The New-Shortcut cmdlet creates a new shortcut with the specified name, target path, and type. 
    The shortcut can be either a file system shortcut or a URL shortcut. 
    Optional arguments and a description can be provided as well.
    .EXAMPLE
    New-Shortcut -Name "MyShortcut" -Target "C:\Program Files\MyApplication" -Type "FileSystem"
    This example creates a new file system shortcut with the name "MyShortcut" that points to the specified target path.
    .EXAMPLE
    New-Shortcut -Name "MyURLShortcut" -Target "https://www.example.com" -Type "URL" -Arguments "-incognito"
    This example creates a new URL shortcut with the name "MyURLShortcut" that points to the specified target URL. 
    The shortcut will include the specified arguments when it is run.
#>
function New-Shortcut(
    # The name for the shortcut
    [Parameter(Mandatory)]
    [Alias("Source", "SourcePath", "Path", "FullName", "FilePath")]
    [string] $Name,

    # The target path for the shortcut
    [Parameter(Mandatory)]
    [Alias("TargetPath", "Destination", "DestinationPath")]
    [string] $Target,

    # The type of shortcut to create. Can be either "FileSystem" or "URL"
    [Parameter(Mandatory)]
    [ValidateSet("FileSystem", "URL")]
    [string] $Type,

    # (Optional) Arguments to pass to the shortcut target
    [string] $Arguments,

    # (Optional) A description for the shortcut
    [string] $Description
) {
    # Instantiate the shell object to create the shortcut
    $Shell = New-Object -ComObject WScript.Shell

    # Create the Shortcut
    $Name = switch ($Type) {
        "FileSystem" { Join-Path $PWD.Path "$Name.lnk" }
        "URL" { Join-Path $PWD.Path "$Name.url" }
    }
    $Shortcut = $Shell.CreateShortcut($Name)

    # Set shortcut properties
    $ShortcutProperties = @{
        TargetPath  = $Target
        Arguments   = $Arguments
        Description = $Description
    }
    $ShortcutObject.SetProperties($ShortcutProperties)

    # Save the Shortcut
    $Shortcut.Save()
}
