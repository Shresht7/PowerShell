Describe 'Import-Library error handling' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $librariesRoot 'Public\Import-Library.ps1')

        function Get-LibraryFile {
            param([string] $Name)
            $null
        }
    }

    It 'throws when the JSON has no library name' {
        $path = Join-Path $TestDrive 'missing-name.json'
        @{ Locations = @() } | ConvertTo-Json | Set-Content -LiteralPath $path

        { Import-Library -Path $path } | Should -Throw '*No library name*'
    }

    It 'throws when the library already exists without Merge' {
        $path = Join-Path $TestDrive 'existing.json'
        @{ Name = 'Existing'; Locations = @() } | ConvertTo-Json | Set-Content -LiteralPath $path

        function Get-LibraryFile {
            param([string] $Name)
            [pscustomobject]@{ Name = $Name }
        }

        { Import-Library -Path $path } | Should -Throw '*already exists*'
    }
}
