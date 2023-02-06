<#
.SYNOPSIS
    Generates a random string
.DESCRIPTION
    Generates a random string. The string is generated using the characters in the $Characters parameter.
.EXAMPLE
    Get-RandomString -Length 10
    Generates a random string of 10 characters
.EXAMPLE
    Get-RandomString -Length 10 -Characters "abc"
    Generates a random string of 10 characters using only the characters "a", "b" and "c"
#>
function Get-RandomString(
    # The length of the random string
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [int32] $Length = 10,

    # The characters to use for the random string
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
) {
    $Random = New-Object System.Random
    $Result = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $Result += $Characters[$Random.Next(0, $Characters.Length)]
    }
    return $Result
}
