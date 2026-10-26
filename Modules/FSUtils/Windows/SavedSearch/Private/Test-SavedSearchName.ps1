function Test-SavedSearchName {
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        throw 'Saved search names cannot be empty or whitespace.'
    }

    if ($Name.EndsWith('.search-ms', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Saved search names must be base names without the '.search-ms' extension."
    }

    if ($Name.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "Saved search name '$Name' contains invalid filename characters."
    }

    $Name
}
