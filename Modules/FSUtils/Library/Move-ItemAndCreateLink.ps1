<#
.SYNOPSIS
    Move the item to the target and leave a symbolic link in its place
.DESCRIPTION
    This function moves the specified item to the target location and creates a symbolic link in its place.
.EXAMPLE
    Move-ItemAndCreateLink -Path "./.config" -Target "~/dotfiles/.config"
    Moves the item at the specified path to the target location and creates a symbolic link in its place.
#>
function Move-ItemAndCreateLink {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The path of the item to be moved. It can be provided as a string or piped from the pipeline.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias('Path', 'Source')]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [string] $Item,

        # The destination path where the item should be moved.
        [Parameter(Mandatory, Position = 1)]
        [Alias('Destination')]
        [string] $Target
    )

    $resolvedItem = (Resolve-Path -LiteralPath $Item).ProviderPath
    $resolvedTarget = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)
    $itemName = Split-Path -Path $resolvedItem -Leaf

    # If destination is an existing directory, Move-Item places the source inside it.
    if (Test-Path -LiteralPath $resolvedTarget -PathType Container) {
        $movedItemPath = Join-Path -Path $resolvedTarget -ChildPath $itemName
    }
    else {
        $movedItemPath = $resolvedTarget
    }

    if ($PSCmdlet.ShouldProcess($resolvedItem, "Move to '$movedItemPath' and create symbolic link")) {
        # Move the item to the target
        Move-Item -LiteralPath $resolvedItem -Destination $resolvedTarget

        # Create a symbolic link in its place
        New-Item -ItemType SymbolicLink -Path $resolvedItem -Value $movedItemPath
    }
}
