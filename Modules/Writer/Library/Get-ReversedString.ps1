# ------------------
# Get-ReversedString
# ------------------

<#
.SYNOPSIS
    Reverses the string
.DESCRIPTION
    A simple function to reverse a `String`
.INPUTS
    System.String
    Takes in a string to reverse
.OUTPUTS
    System.String
    The reversed string
.EXAMPLE
    Get-ReversedString "Hello World!"
    Return the string "!dlroW olleH"
.EXAMPLE
    "12345" | Get-ReversedString
    Returns the string "54321"
.EXAMPLE
    "PipeLine" | Get-ReversedString
    Can accept input from the pipeline
.EXAMPLE
    Get-ReversedString this is all one string
    Can also assume the string from the remaining arguments
#>
function Get-ReversedString(
    # The string to reverse
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        ValueFromRemainingArguments
    )]
    [Alias("Text")]
    [string] $String
) {
    $InputArray = $String.ToCharArray()
    $ReversedString = ""
    for ($i = $InputArray.Length; $i -ge 0; $i--) {
        $ReversedString += $InputArray[$i]
    }
    return $ReversedString
}
