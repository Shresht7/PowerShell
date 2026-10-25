<#
.SYNOPSIS
    Resolves a library location URL to a path
.DESCRIPTION
    Supports knownfolder URLs and returns the path
#>
function Resolve-LibraryLocation {

    [CmdletBinding()]
    param(
        # The library location URL to resolve 
        [Parameter(Mandatory)]
        [string] $URL
    )

    # Handle knownfolder URLs
    if ($URL -match '^knownfolder:(\{.+\})$') {
        try {
            return Resolve-KnownFolder -Id ([guid] $Matches[1])
        }
        catch {
            return $URL
        }
    }

    # Return URL if not knownfolder
    return $URL
}
