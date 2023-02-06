<#
.SYNOPSIS
    Get examples for a cmdlet
.DESCRIPTION
    Extracts example code, title and remarks as PowerShell objects from
    the respectively cmdlet's help
.EXAMPLE
    Get-HelpExample -Command Get-ChildItem
    Get examples for the `Get-ChildItem` cmdlet
.EXAMPLE
    "Set-Location" | Get-HelpExample
    Get examples for the `Set-Location` cmdlet
.LINK
    https://github.com/DBremen/PowerShellScripts/blob/master/Extend%20Builtin/Get-HelpExamples.ps1
#>
function Get-HelpExample(
    # Name of the command
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('Command', 'CommandName')]
    [string] $Name
) {
    (Get-Help -Name $Name).examples.example | ForEach-Object {
        [PSCustomObject]@{
            Title   = $_.title
            Code    = $_.Code.Split("`n") | ForEach-Object {
                if ($_.StartsWith('PS C:\>')) {
                    $_.replace('PS C:\>', '')
                }
                else {
                    "# $_"
                }
            } | Out-String
            Remarks = $_.Remarks | Out-String 
        }
    }
}

Export-ModuleMember -Function Get-HelpExample
