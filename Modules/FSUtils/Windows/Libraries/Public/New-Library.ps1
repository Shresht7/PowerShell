<#
.SYNOPSIS
    Creates a new library
.DESCRIPTION
    Creates a new Windows library with the given name
.EXAMPLE
    New-Library 'MyLib'
    # Creates 'MyLib' library
#>
function New-Library {
    
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Name of the library to create
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name
    )

    if ($PSCmdlet.ShouldProcess($Name, 'Create Library')) {
        $LibPath = Get-LibraryPath
        [FSUtils.WindowsLibraries.ShellLibraryInterop]::Create($LibPath, $Name)
    }
}
