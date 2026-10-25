<#
.SYNOPSIS
    Reverses the string
.DESCRIPTION
    A simple function to reverse a string
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
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ValueFromRemainingArguments)]
    [Alias("String", "Input", "InputObject", "Name", "FullName", "InputString")]
    [string] $Text
) {

    $TextElements = [System.Globalization.StringInfo]::ParseCombiningCharacters($Text)

    $ReversedText = for ($Index = $TextElements.Count - 1; $Index -ge 0; $Index--) {
        $Start = $TextElements[$Index]
        if ($Index -eq $TextElements.Count - 1) {
            $Length = $Text.Length - $Start
        }
        else {
            $Length = $TextElements[$Index + 1] - $Start
        }
        $Text.Substring($Start, $Length)
    }

    -join $ReversedText

}
