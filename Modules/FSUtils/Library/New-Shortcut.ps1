<#
    .SYNOPSIS
    Creates a new shortcut
    .DESCRIPTION
    The New-Shortcut cmdlet creates a new shortcut with the specified name, target path, and type. 
    The shortcut can be either a file system shortcut or a URL shortcut. 
    Optional arguments and a description can be provided as well.
    .EXAMPLE
    New-Shortcut -Name "MyShortcut" -TargetPath "C:\Program Files\MyApplication" -Type "FileSystem"
    This example creates a new file system shortcut with the name "MyShortcut" that points to the specified target path.
    .EXAMPLE
    New-Shortcut -Name "MyURLShortcut" -TargetPath "https://www.example.com" -Type "URL"
    This example creates a new URL shortcut with the name "MyURLShortcut" that points to the specified target URL. 
    The shortcut will include the specified arguments when it is run.
#>
function New-Shortcut {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The name for the shortcut
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [Alias("Source", "SourcePath", "FilePath")]
        [string] $Name,

        # The target path for the shortcut
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("Target", "Destination", "DestinationPath", "Path", "FullName", "Url", "Uri", "Definition")]
        [string] $TargetPath,

        # The type of shortcut to create. Use Auto to infer from input.
        [ValidateSet("Auto", "FileSystem", "URL")]
        [string] $Type = "Auto",

        # (Optional) Arguments to pass to the shortcut target
        [string] $Arguments,

        # (Optional) A description for the shortcut
        [string] $Description,

        # Output directory for created shortcuts.
        [Alias("Output", "Directory", "DestinationDirectory")]
        [string] $OutputDirectory = $PWD.Path
    )

    begin {
        try {
            # Instantiate the shell object once for pipeline scenarios.
            $Shell = New-Object -ComObject WScript.Shell -ErrorAction Stop

            $ResolvedOutputDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
            if (-not (Test-Path -LiteralPath $ResolvedOutputDirectory -PathType Container)) {
                $null = New-Item -ItemType Directory -Path $ResolvedOutputDirectory -Force -ErrorAction Stop
            }
        }
        catch {
            throw "Failed to initialize New-Shortcut: $($_.Exception.Message)"
        }
    }

    process {
        $ResolvedType = $Type
        $ResolvedTargetPath = $TargetPath
        $ResolvedName = $Name

        $Uri = $null
        $IsUrl = [uri]::TryCreate($ResolvedTargetPath, [UriKind]::Absolute, [ref]$Uri)

        if ($ResolvedType -eq "Auto") {
            $ResolvedType = if ($IsUrl) { "URL" } else { "FileSystem" }
        }

        if ($ResolvedType -eq "FileSystem") {
            if (-not (Test-Path -LiteralPath $ResolvedTargetPath)) {
                $Command = Get-Command -Name $ResolvedTargetPath -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($Command) {
                    if ($Command.Source -and (Test-Path -LiteralPath $Command.Source)) {
                        $ResolvedTargetPath = $Command.Source
                        if (-not $ResolvedName) { $ResolvedName = $Command.Name }
                    }
                    elseif ($Command.Definition -and (Test-Path -LiteralPath $Command.Definition)) {
                        $ResolvedTargetPath = $Command.Definition
                        if (-not $ResolvedName) { $ResolvedName = $Command.Name }
                    }
                }
            }

            if (-not (Test-Path -LiteralPath $ResolvedTargetPath)) {
                Write-Error "Could not resolve a valid filesystem target from '$TargetPath'."
                return
            }

            $ResolvedTargetPath = (Resolve-Path -LiteralPath $ResolvedTargetPath).ProviderPath
            if (-not $ResolvedName) {
                $ResolvedName = Split-Path -Path $ResolvedTargetPath -Leaf
            }
        }
        else {
            if (-not $IsUrl) {
                Write-Error "Target '$TargetPath' is not a valid absolute URL."
                return
            }

            $ResolvedTargetPath = $Uri.AbsoluteUri
            if (-not $ResolvedName) {
                $ResolvedName = if ($Uri.Host) { $Uri.Host } else { "URLShortcut" }
            }
        }

        $SafeName = [System.IO.Path]::GetFileNameWithoutExtension($ResolvedName)
        if (-not $SafeName) {
            $SafeName = "Shortcut_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        }

        $ShortcutPath = switch ($ResolvedType) {
            "FileSystem" { Join-Path $ResolvedOutputDirectory "$SafeName.lnk" }
            "URL" { Join-Path $ResolvedOutputDirectory "$SafeName.url" }
        }

        if (-not $PSCmdlet.ShouldProcess($ShortcutPath, "Create $ResolvedType shortcut")) {
            return
        }

        try {
            $Shortcut = $Shell.CreateShortcut($ShortcutPath)

            # Set shortcut properties
            switch ($ResolvedType) {
                "FileSystem" {
                    $Shortcut.TargetPath = $ResolvedTargetPath
                    $Shortcut.Description = $Description
                    $Shortcut.Arguments = $Arguments
                }
                "URL" {
                    $Shortcut.TargetPath = $ResolvedTargetPath
                }
            }

            # Save the Shortcut
            $Shortcut.Save()
        }
        catch {
            Write-Error "Failed to create shortcut '$ShortcutPath': $($_.Exception.Message)"
        }
    }
}
