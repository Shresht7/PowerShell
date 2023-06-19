<#
.SYNOPSIS
    Invoke the cheat.sh API
.DESCRIPTION
    Invoke the cheat.sh API to get cheat sheets for various programming languages and tools.
#>

[CmdletBinding()]
Param(
    # The programming language or tool to get a cheat sheet for (e.g. python)
    [Parameter(
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        Position = 0
    )]
    [string] $Language,

    # The topic to get a cheat sheet for (e.g. for loop)
    [Parameter(
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        ValueFromRemainingArguments
    )]
    [string] $Topic
)

# Prompt the user for the Language and Topic parameters if they are not specified
if (-not $Language) {
    $Language = Read-Host -Prompt 'Language'
}
if (-not $Topic) {
    $Topic = Read-Host -Prompt 'Topic'
}

# Build the query if the Language and Topic parameters are specified
$Topic = $Topic -join '+'
$Query = "$Language/$Topic"

# Invoke the cheat.sh API
$Response = Invoke-WebRequest -Uri "https://cheat.sh/$Query" 

# Write the response body to the console
$Response.Content
