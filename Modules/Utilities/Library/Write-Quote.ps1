<#
.SYNOPSIS
    Write a random quote to the console.
.DESCRIPTION
    Write a random quote to the console.
.EXAMPLE
    Write-Quote
    Write a random quote to the console.
.EXAMPLE
    Write-Quote -Path "C:\Users\JohnDoe\quotes.csv"
    Write a random quote to the console from the specified quotes file.
.EXAMPLE
    Write-Quote -Separator "-"
    Write a random quote to the console with a separator of hyphens.
.EXAMPLE
    Write-Quote -Color $PSStyle.Foreground.BrightCyan
    Write a random quote to the console with a cyan separator.
.NOTES
    Expects a CSV file with the following columns:
    - Quote
    - Author
    - Source
    - Tags
    - Date
    - Link
    - Notes
    - Favorite
    - ID
#>
function Write-Quote(
    # The path to the quotes file
    [Alias("From")]
    [string]$Path = "$PSScriptRoot\quotes.csv",

    # The separator character
    [string]$Separator = "=",

    # The color of the separator
    [string]$Color = $PSStyle.Foreground.BrightMagenta
) {
    # Import the quotes
    $Quotes = Import-Csv -Path $Path

    # Get a random quote
    $Quote = $Quotes | Get-Random
    $QuoteMessage = " $($Quote.Quote)"
    $QuoteAuthor = "  -- $($Quote.Author)"

    # Create separator
    $SeparatorLine = " " + $Color + ($Separator * $QuoteMessage.Length) + $PSStyle.Reset
    
    # Display the quote
    Write-Host ""
    Write-Host $SeparatorLine
    Write-Host $QuoteMessage
    if ($Quote.Author) {
        Write-Host $QuoteAuthor -ForegroundColor DarkGray
    }
    Write-Host $SeparatorLine
    Write-Host ""

}
