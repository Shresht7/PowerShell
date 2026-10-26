Describe 'Get-LibraryPath' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $librariesRoot 'Private\Get-LibraryPath.ps1')
    }

    It 'returns the Windows Libraries directory when it exists' {
        $path = Get-LibraryPath

        $path | Should -Be (Join-Path $env:APPDATA 'Microsoft\Windows\Libraries')
        Test-Path -LiteralPath $path -PathType Container | Should -BeTrue
    }
}

Describe 'Open-Library' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $librariesRoot 'Private'
        $publicRoot = Join-Path $librariesRoot 'Public'

        . (Join-Path $privateRoot 'Get-LibraryFile.ps1')
        . (Join-Path $publicRoot 'Open-Library.ps1')

        $libraryPath = Join-Path $TestDrive 'Libraries'
        New-Item -ItemType Directory -Path $libraryPath | Out-Null
        $libraryFile = Join-Path $libraryPath 'Project Files.library-ms'
        New-Item -ItemType File -Path $libraryFile | Out-Null

        function Get-LibraryPath { $libraryPath }
        function Get-LibraryFile {
            param([string] $Name)
            if ($Name) {
                Get-Item -LiteralPath (Join-Path $libraryPath "$Name.library-ms") -ErrorAction SilentlyContinue
            }
            else {
                Get-ChildItem -LiteralPath $libraryPath -Filter '*.library-ms'
            }
        }
    }

    It 'opens a named library in Explorer' {
        Mock Start-Process

        Open-Library -Name 'Project Files'

        Should -Invoke Start-Process -Exactly 1 -ParameterFilter {
            $FilePath -eq 'explorer.exe' -and
            $ArgumentList -eq ('"' + $libraryFile + '"')
        }
    }

    It 'opens the Libraries directory without a name' {
        Mock Start-Process

        Open-Library

        Should -Invoke Start-Process -Exactly 1 -ParameterFilter {
            $FilePath -eq 'explorer.exe' -and
            $ArgumentList -eq ('"' + $libraryPath + '"')
        }
    }

    It 'reports a missing library without starting Explorer' {
        Mock Start-Process

        Open-Library -Name 'Missing' -ErrorAction SilentlyContinue

        Should -Invoke Start-Process -Exactly 0
    }
}

Describe 'Find-LibraryPath' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $librariesRoot 'Private'
        $publicRoot = Join-Path $librariesRoot 'Public'

        . (Join-Path $publicRoot 'Find-LibraryPath.ps1')

        function Get-Library {
            [pscustomobject]@{ Name = 'Project Files' }
        }

        function Get-LibraryFolder {
            [pscustomobject]@{
                Type                  = 'FileSystem'
                ResolvedPath          = 'C:\Projects'
                URL                   = 'C:\Projects'
                IsDefaultSaveLocation = $true
            }
        }
    }

    It 'returns matching library locations' {
        $result = Find-LibraryPath -SearchPath 'C:\Projects\'

        $result.Library | Should -Be 'Project Files'
        $result.Path | Should -Be 'C:\Projects'
        $result.IsDefaultSaveLocation | Should -BeTrue
    }

    It 'accepts pipeline path properties' {
        $result = [pscustomobject]@{ FullName = 'C:\Projects' } | Find-LibraryPath

        $result.Library | Should -Be 'Project Files'
    }
}
