<#
.SYNOPSIS
    Remove a Windows library by name
.DESCRIPTION
    Removes a Windows library by name.
    Does not remove default Windows libraries.
    Simply deletes the corresponding *.library-ms file
.EXAMPLE
    Remove-Library -Name "MyLibrary"
    # Removes the library named MyLibrary
.EXAMPLE
    Get-Library OtherLib | Remove-Library
    # Removes OtherLib using the pipeline
#>
function Remove-Library {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    param(
        # Name of the library to remove
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    begin {
        $defaultLibraries = @(
            "Camera Roll",
            "Documents",
            "Music", 
            "Pictures", 
            "SavedPictures",
            "Videos"
        )
    }

    process {
        $resolvedPath = Resolve-LibraryPath $Name
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($resolvedPath)

        if ($defaultLibraries -contains $baseName) {
            Write-Error "Cannot remove default library '$baseName'"
            return
        }

        if ($PSCmdlet.ShouldProcess($Name, "Remove library")) {
            Remove-Item -LiteralPath $resolvedPath
        }

    }

}
