Describe 'Open-SavedSearch' {
    BeforeAll {
        $savedSearchRoot = Split-Path -Parent $PSScriptRoot
        $privateRoot = Join-Path $savedSearchRoot 'Private'
        $publicRoot = Join-Path $savedSearchRoot 'Public'

        . (Join-Path $privateRoot 'Get-SavedSearchFile.ps1')
        . (Join-Path $privateRoot 'Resolve-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Get-SavedSearchPath.ps1')
        . (Join-Path $publicRoot 'Open-SavedSearch.ps1')

        $testSearchPath = Join-Path $TestDrive 'Searches'
        New-Item -ItemType Directory -Path $testSearchPath | Out-Null
        '<persistedQuery version="1.0" />' | Set-Content -LiteralPath (Join-Path $testSearchPath 'Open Me.search-ms')

        function Get-SavedSearchPath {
            $testSearchPath
        }
    }

    It 'opens a named saved search in Explorer' {
        Mock Start-Process

        Open-SavedSearch -Name 'Open Me'

        Should -Invoke Start-Process -Exactly 1 -ParameterFilter {
            $FilePath -eq 'explorer.exe' -and
            $ArgumentList -eq ('"' + (Join-Path $testSearchPath 'Open Me.search-ms') + '"')
        }
    }

    It 'opens the Searches folder when no name is supplied' {
        Mock Start-Process

        Open-SavedSearch

        Should -Invoke Start-Process -Exactly 1 -ParameterFilter {
            $FilePath -eq 'explorer.exe' -and
            $ArgumentList -eq ('"' + $testSearchPath + '"')
        }
    }

    It 'accepts pipeline input by property name' {
        Mock Start-Process

        [pscustomobject]@{ Name = 'Open Me' } | Open-SavedSearch

        Should -Invoke Start-Process -Exactly 1
    }
}
