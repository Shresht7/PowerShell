<#
.SYNOPSIS
    Creates a new library
.DESCRIPTION
    Creates a new Windows library with the given name at the specified location
.EXAMPLE
    New-Library 'MyLib'
    # Creates 'MyLib' library
.EXAMPLE
    New-Library 'References' -Path .
    # Creates 'References' library in current location
#>
function New-Library {
    
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Name of the library to create
        [Parameter(Mandatory)]
        [Alias('Library', 'LibraryName')]
        [string] $Name,

        # Path to create the library at
        [string] $Path = (Get-LibraryPath),

        # Return the created file
        [switch] $PassThru
    )

    Initialize-ShellLibraryInterop

    if ($PSCmdlet.ShouldProcess($Name, "Create Library in '$Path'")) {
        $LibPath = Resolve-Path -Path $Path
        [PSFSUtils.WindowsLibraries.ShellLibraryInterop]::Create($LibPath, $Name)
        if ($PassThru) {
            Get-Item -LiteralPath $LibPath
        }
    }
}
