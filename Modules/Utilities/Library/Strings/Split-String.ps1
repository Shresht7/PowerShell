<#
.SYNOPSIS
Splits a string

.DESCRIPTION
This function takes a string and splits it using the specified delimiter (by default, one or more whitespace characters). 
You can also specify an array of indices to return specific parts of the split string.

.PARAMETER InputObject
The string to split. This parameter is mandatory and can be provided via the pipeline or by property name.

.PARAMETER Delimiter
The delimiter to use for splitting the string. Default is one or more whitespace characters.

.PARAMETER Index
An optional array of indices to return specific split elements. If not provided, the entire split array is returned.

.EXAMPLE
PS> "apple orange banana" | Split-String
Returns: "apple", "orange", "banana"

.EXAMPLE
PS> "apple,orange,banana" | Split-String -Delimiter ","
Returns: "apple", "orange", "banana"

.EXAMPLE
PS> "apple orange banana" | Split-String -Delimiter '\s+' -Index 1
Returns: "orange"

.EXAMPLE
PS> "apple orange banana" | Split-String -Delimiter '\s+' -Index 0,2
Returns: "apple", "banana"

.NOTES
File Name      : Split-String.ps1
Author         : Shresht7
Prerequisite   : PowerShell 3.0
#>
function Split-String(
    # The string to split. This parameter is mandatory and can be provided via the pipeline or by property name.
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]] $String,

    # The delimiter to use for splitting the string. Default is one or more whitespace characters.
    [string] $Delimiter = "\s+",

    # An optional array of indices to return specific split elements. If not provided, the entire split array is returned.
    [Alias("Fields")]
    [int[]] $Index
) {
    process {
        # Split the string using the delimiter
        $SplitString = $String -split $Delimiter

        # If an index (or indices) were specified, return the corresponding elements ...
        if ($null -ne $Index) {
            return $SplitString[$Index]
        }
        # ... otherwise return the entire array
        return $SplitString
    }
}

Set-Alias cut Split-String
Export-ModuleMember -Alias cut
