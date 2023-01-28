<#
.SYNOPSIS
    Move the item to the target and leave a symbolic link in its place
.DESCRIPTION
    Move the item to the target and leave a symbolic link in its place.
.EXAMPLE
    Move-ItemAndLink -Path "./.config" -Target "~/dotfiles/.config"
#>
function Move-ItemAndLink(
    [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Path', 'Source')]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Item,

    [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [Alias('Destination')]
    [string] $Target
) {
    # Test for administrator privileges
    if (-not (Test-IsElevated)) {
        Write-Error -Message "Administrator privileges are required to move the item and create a symbolic link."
        return
    }

    # Move the item to the target
    Move-Item -Path $Item -Destination $Target
    # Create a symbolic link in its place
    New-Item -ItemType SymbolicLink -Path $Item -Value $Target
}
