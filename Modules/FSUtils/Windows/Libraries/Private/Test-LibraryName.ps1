<#
.SYNOPSIS
    Validates a library name
.DESCRIPTION
    Ensures the name is valid for a library
#>
function Test-LibraryName {
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        throw 'Library names cannot be empty or whitespace.'
    }

    if ($Name.EndsWith('.library-ms', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Library names must be base names without the '.library-ms' extension."
    }

    if ($Name.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "Library name '$Name' contains invalid filename characters."
    }

    $Name
}
