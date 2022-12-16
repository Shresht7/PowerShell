<#
.SYNOPSIS
    Displays a prompt to the user and waits for them to press a key.
.DESCRIPTION
    This function displays a prompt to the user and waits for them to press a key. It is similar to the
    `Read-Host` function, but it does not return the key that was pressed.
.EXAMPLE
    Suspend-Host
    Displays a prompt to the user and waits for them to press a key.
#>
function Suspend-Host(
    # The message to display to the user. Defaults to "Press any key to continue...".
    [Parameter(Mandatory = $false, Position = 0)]
    [string] $Message = "Press any key to continue..."
) {
    Write-Host $Message
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
