<#
.SYNOPSIS
    Move the item to the target and leave a symbolic link in its place
.DESCRIPTION
    This function moves the specified item to the target location and creates a symbolic link in its place.
.EXAMPLE
    Move-ItemAndCreateLink -Path "./.config" -Target "~/dotfiles/.config"
    Moves the item at the specified path to the target location and creates a symbolic link in its place.
#>
function Move-ItemAndCreateLink(
    # The path of the item to be moved. It can be provided as a string or piped from the pipeline.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Path', 'Source')]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Item,

    # The destination path where the item should be moved.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [Alias('Destination')]
    [string] $Target
) {
    # Test for administrator privileges
    if (-not (Test-IsElevated)) {
        throw "Administrator privileges are required to move the item and create a symbolic link."
    }

    # Move the item to the target
    Move-Item -Path $Item -Destination $Target

    # Create a symbolic link in its place
    New-Item -ItemType SymbolicLink -Path $Item -Value $Target
}
