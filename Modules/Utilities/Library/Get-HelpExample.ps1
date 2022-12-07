<#
.SYNOPSIS
    Get examples for a cmdlet
.DESCRIPTION
    Extracts example code, title and remarks as PowerShell objects from
    the respectively cmdlet's help
.LINK
    https://github.com/DBremen/PowerShellScripts/blob/master/Extend%20Builtin/Get-HelpExamples.ps1
#>
function Get-HelpExample(
    # Name of the command
    [Parameter(Mandatory)]
    [string] $Command
) {
    (Get-Help $Command).examples.example | ForEach-Object {
        [PSCustomObject]@{
            Code    = $_.Code.Split("`n") | ForEach-Object {
                if ($_.StartsWith('PS C:\>')) {
                    $_.replace('PS C:\>', '')
                }
                else {
                    "# $_"
                }
            } | Out-String
            Title   = $_.Title
            Remarks = $_.Remarks | Out-String 
        }
    }
}

Export-ModuleMember -Function Get-HelpExample
