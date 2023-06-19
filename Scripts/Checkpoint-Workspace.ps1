<#
.SYNOPSIS
    Record the state of a folder and its subfolders.
.DESCRIPTION
    Record the state of a folder and its subfolders.
    The state is recorded as a JSON file that can be used to visualize the folder structure.
.NOTES
    Workspace-Visualizer is a cli tool to generate visualizations based on the file-system structure
    # TODO: Add the url to the github repository here
#>
function Checkpoint-Workspace {

    [CmdletBinding()]
    param (
        # The name of the source folder to track
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Source,

        # The paths to include in the snapshot
        [string]$Include,

        # The paths to exclude from the snapshot
        [string]$Exclude,

        # The path to the destination folder to store the snapshots
        [Parameter(Mandatory)]
        [string]$Destination
    )

    begin {
        # Check if workspace-visualizer binary is installed
        if (-not (Find-Path workspace-visualizer)) {
            # TODO: Add link to the workspace-visualizer repository
            throw "Workspace-Visualizer not found! Please install it from ..."
        }
    }

    process {
        # Check if the source folder exists
        if (-not (Test-Path "$Source")) {
            Write-Error -Message "Source folder ``$Source`` not found!"
            return
        }
    
        # Get the name of the source folder
        $Name = Split-Path -Path $Source -Leaf
    
        # Check if the destination folder exists
        if (-not (Test-Path "$Destination\$Name")) {
            # Create the destination folder
            $null = New-Item -ItemType Directory -Path "$Destination\$Name"
        }
    
        # Get the current date
        $Date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
    
        # Create a snapshot of the source folder and store it in the destination folder
        workspace-visualizer snapshot --path $Source --output "$Destination\$Name\$Date.json" --exclude $Exclude --include $Include
    }

    end {}

}

# ======
# SCRIPT
# ======

# Define the paths to track
$Paths = @(
    # @{
    #     Path    = "$HOME\OneDrive"
    #     Exclude = @('*') -join " "
    #     Include = @(
    #         'Documents',
    #         'Pictures',
    #         'Public'
    #     ) -join " "
    # }
    # @{
    #     Path    = "$HOME\Documents"
    #     Exclude = @('*') -join " "
    #     Include = @(
    #         'Excalidraw',
    #         "'My Games'"

    #     ) -join " "
    # }
    # @{
    #     Path    = "$HOME\Pictures"
    #     Exclude = @('') -join " "
    #     Include = @('') -join " "
    # }
    # @{
    #     Path    = "$HOME\Music"
    #     Exclude = @('') -join " "
    #     Include = @('') -join " "
    # }
    # @{
    #     Path    = "$HOME\Videos"
    #     Exclude = @('') -join " "
    #     Include = @('') -join " "
    # }
    # @{
    #     Path    = "$HOME\Data"
    #     Exclude = @('*') -join " "
    #     Include = @('') -join " "
    # }
    @{
        Path    = "$HOME\Projects"
        Exclude = @('') -join " "
        Include = @('') -join " "
    }
    @{
        Path    = "$HOME\Notebooks"
        Exclude = @('') -join " "
        Include = @('') -join " "
    }
)

# Track the paths
$Paths | ForEach-Object {
    Checkpoint-Workspace -Source $_.Path -Exclude $_.Exclude -Include $_.Include -Destination "$HOME\Data\Workspace-History"
}
