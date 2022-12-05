<#
.SYNOPSIS
    Wait for the host to press any key
.DESCRIPTION
    Waits for the host to press any key before continuing the script
.EXAMPLE
    Wait-Host
    Waits for the user to press a key
#>
function Wait-Host() {
    Write-Output "Press Any Key To Continue ..."
    $null = $Host.Ui.RawUI.ReadKey("Noecho,Includekeydown")
}
