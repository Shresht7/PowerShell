<#
.SYNOPSIS
    Generates a random string.
.DESCRIPTION
    Generates a non-cryptographic random string using the characters in the $Character parameter.
.EXAMPLE
    New-RandomString -Length 10
    Generates a random string of 10 characters
.EXAMPLE
    New-RandomString -Length 10 -Characters "abc"
    Generates a random string of 10 characters using only the characters "a", "b" and "c"
.NOTES
    This function is not suitable for passwords, secrets, tokens or other security-sensitive values
#>
function New-RandomString(
    # The length of the random string
    [Parameter(ValueFromPipelineByPropertyName)]
    [UInt32] $Length = 10,

    # The characters to use for the random string
    [Parameter(ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string] $Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
) {
    $charArray = $Characters.ToCharArray()
    $randomChars = for ($i = 0; $i -lt $Length; $i++) {
        Get-Random -InputObject $charArray
    } 
    -join $randomChars
}
