<#
.SYNOPSIS
    Generates a random string.
.DESCRIPTION
    Generates a random string. The string is generated using the characters in the $Characters parameter.
.EXAMPLE
    New-RandomString -Length 10
    Generates a random string of 10 characters
.EXAMPLE
    New-RandomString -Length 10 -Characters "abc"
    Generates a random string of 10 characters using only the characters "a", "b" and "c"
#>
function New-RandomString(
    # The length of the random string
    [Parameter(ValueFromPipelineByPropertyName)]
    [UInt32] $Length = 10,

    # The characters to use for the random string
    [Parameter(ValueFromPipeline)]
    [string] $Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
) {
    $charArray = $Characters.ToCharArray()
    $randomChars = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $randomChar = Get-Random -InputObject $charArray
        $randomChars += $randomChar
    }
    return $randomChars
}
