# ------------------
# Get-ReversedString
# ------------------

<#
.SYNOPSIS
    Reverses the string
.DESCRIPTION
    A simple function to reverse a `String`
.EXAMPLE
    Get-ReversedString -String "Hello World!"
    Return the string "!dlroW olleH"
#>
function Get-ReversedString(
    # The string to reverse
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
