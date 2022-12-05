<#
.SYNOPSIS
    Reverses the string
.DESCRIPTION
    A simple function to reverse a `String`
.PARAMETER $Input
    The string to reverse
.EXAMPLE
    Get-ReversedString "Hello World!"
#>
function Get-ReversedString(
    [Parameter(Mandatory)]
    [string] $String
) {
    $InputArray = $String.ToCharArray()
    $ReversedString = ""
    for ($i = $InputArray.Length; $i -ge 0; $i--) {
        $ReversedString += $InputArray[$i]
    }
    return $ReversedString
}
