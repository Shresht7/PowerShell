<#
.SYNOPSIS
    Resolves a known folder ID to its path
.DESCRIPTION
    Uses the KnownFolder API to get the path of a folder by its ID
#>
function Resolve-KnownFolder {

    [CmdletBinding()]
    param(
        # The known folder ID to resolve (GUID)
        [Parameter(Mandatory)]
        [Guid] $Id
    )

    Initialize-ShellLibraryInterop

    [PSFSUtils.Shell.KnownFolders]::GetPath($Id)
}
