#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

BeforeAll {
    # Load the module (this also compiles ShellLibrary.cs)
    . "$PSScriptRoot\..\..\Initialize.ps1"

    # Everything below touches ONLY this uniquely named library
    $LibName = "PesterTest-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    $LibFile = Join-Path (Get-LibraryPath) "$LibName.library-ms"

    $Root = Join-Path $Env:TEMP $LibName
    $FolderA = Join-Path $Root "A"
    $FolderB = Join-Path $Root "B"
    $FolderStale = Join-Path $Root "Stale"
    New-Item -ItemType Directory -Path $FolderA, $FolderB, $FolderStale | Out-Null
}

AfterAll {
    # Cleanup, guarded so it can only ever delete our own test library
    if ($LibName -like 'PesterTest-*') {
        if (Test-Path -LiteralPath $LibFile) { Remove-Item -LiteralPath $LibFile -Force }
        if (Test-Path -LiteralPath $Root) { Remove-Item -LiteralPath $Root -Recurse -Force }
    }
}

# NOTE: These tests build on each other and must be run in order
Describe "Library Lifecycle" {

    Context 'New-Library' {
        It 'creates the .library-ms file' {
            New-Library -Name $LibName
            Test-Path -LiteralPath $LibFile | Should -BeTrue
        }

        It 'shows up in Get-Library' {
            (Get-Library -Name $LibName).Name | Should -Be $LibName
        }
    }

    Context 'Add-LibraryFolder' {
        It 'adds a folder to the library' {
            Add-LibraryFolder -Library $LibName -Path $FolderA
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Contain $FolderA
        }

        It 'adds a second folder' {
            Add-LibraryFolder -Library $LibName -Path $FolderB
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Contain $FolderB
        }

        It 'fails with a readable error for a missing library' {
            { Add-LibraryFolder -Library 'PesterTest-DoesNotExist' -Path $FolderA } | Should -Throw -ExpectedMessage '*not found*'
        }

        It 'rejects a path that is not a valid folder' {
            $file = Join-Path $Root 'file.txt'
            Set-Content -LiteralPath $file -Value 'x'
            { Add-LibraryFolder -Library $LibName -Path $file -ErrorAction Stop } | Should -Throw -ExpectedMessage "*not a folder*"
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Not -Contain $file
        }
    }

    Context 'Set-LibraryDefaultSaveFolder' {
        It 'marks the chosen folder as the default' {
            Set-LibraryDefaultSaveFolder -Library $LibName -Path $FolderB
            $folders = Get-LibraryFolder -Name $LibName
            ($folders | Where-Object ResolvedPath -eq $FolderB).IsDefaultSaveLocation | Should -BeTrue
            ($folders | Where-Object ResolvedPath -eq $FolderA).IsDefaultSaveLocation | Should -BeFalse
        }
    }

    Context 'Remove-LibraryFolder' {
        It 'removes a folder' {
            Remove-LibraryFolder -Library $LibName -Path $FolderA
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Not -Contain $FolderA
        }

        It 'removes a stale entry whose folder was deleted' {
            Add-LibraryFolder -Library $LibName -Path $FolderStale
            Remove-Item -LiteralPath $FolderStale -Recurse -Force
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Contain $FolderStale
            Remove-LibraryFolder -Name $LibName -Path $FolderStale
            (Get-LibraryFolder -Name $LibName).ResolvedPath | Should -Not -Contain $FolderStale
        }
    }

    Context 'Remove-Library' {
        It 'refuses to remove a default library' {
            { Remove-Library -Name 'Documents' -WhatIf -ErrorAction Stop } | Should -Throw
        }

        It 'refuses the .library-ms spelling of a default library' {
            { Remove-Library -Name 'Documents.library-ms' -WhatIf -ErrorAction Stop } | Should -Throw
        }

        It 'deletes the test library' {
            Remove-Library -Name $LibName -Confirm:$false
            Test-Path -LiteralPath $LibFile | Should -BeFalse
        }
    }

}

Describe 'Known Folders' {

    BeforeAll {
        $DocumentsId = [guid]'FDD39AD0-238F-46AF-ADB4-6C85480369C7'
    }

    Context 'Resolve-KnownFolder' {
        It 'resolves the Documents known folder' {
            Resolve-KnownFolder -Id $DocumentsId | Should -Be ([Environment]::GetFolderPath('MyDocuments'))
        }

        It 'returns the same result on a second call' {
            # Regression: the old inline Add-Type failed on every call after the first
            $first = Resolve-KnownFolder -Id $DocumentsId
            $second = Resolve-KnownFolder -Id $DocumentsId
            $second | Should -Be $first
        }

        It 'throws for an unknown known folder id' {
            { Resolve-KnownFolder -Id ([guid]::NewGuid()) } | Should -Throw
        }
    }

    Context 'Resolve-LibraryLocation' {
        It 'returns exactly one value for a known folder URL' {
            # Regression: a missing return used to emit both the path and the URL
            $result = @(Resolve-LibraryLocation -Url "knownfolder:{$DocumentsId}")
            $result.Count | Should -Be 1
            $result[0] | Should -Be ([Environment]::GetFolderPath('MyDocuments'))
        }

        It 'falls back to the raw URL for an unknown known folder' {
            $url = "knownfolder:{$([guid]::NewGuid())}"
            Resolve-LibraryLocation -URL $url | Should -Be $url
        }

        It 'passes a plain path through unchanged' {
            Resolve-LibraryLocation -URL 'C:\Some\Path' | Should -Be 'C:\Some\Path'
        }
    }

    Context 'Get-LibraryFolder on Documents' {
        BeforeAll {
            $folders = @(Get-LibraryFolder -Name 'Documents')
        }

        It 'returns at least one folder' {
            $folders.Count | Should -BeGreaterThan 0
        }

        It 'resolves every known folder entry to a single path string' {
            foreach ($f in $folders.Where({ $_.Type -eq 'KnownFolder' })) {
                $f.ResolvedPath | Should -BeOfType [string]
                $f.ResolvedPath | Should -Not -BeLike 'knownfolder:*'
            }
        }

        It 'marks exactly one entry as the default save location' {
            @($folders.Where({ $_.IsDefaultSaveLocation })).Count | Should -Be 1
        }
    }

}

Describe 'Import-Library' {

    BeforeAll {
        $name = "PesterImport-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $root = Join-Path $env:TEMP $name
        $a = Join-Path $root 'A'
        $b = Join-Path $root 'B'
        New-Item -ItemType Directory -Path $a, $b | Out-Null

        $json = Join-Path $root 'lib.json'
        @{
            Name      = $name
            Locations = @(
                @{ URL = $a; IsDefaultSaveLocation = $true }
                @{ URL = $b }
                @{ URL = (Join-Path $root 'Missing') }
            )
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $json
    }

    AfterAll {
        if ($name -like 'PesterImport-*') {
            $file = Join-Path (Get-LibraryPath) "$name.library-ms"
            if (Test-Path -LiteralPath $file) { Remove-Item -LiteralPath $file -Force }
            Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'creates the library with the existing folders and skips missing ones' {
        Import-Library -Path $json -WarningAction SilentlyContinue | Out-Null
        $folders = @(Get-LibraryFolder -Name $name)

        $folders.ResolvedPath | Should -Contain $a
        $folders.ResolvedPath | Should -Contain $b
        $folders.Count | Should -Be 2
    }

    It 'sets the default save location' {
        ($folders = Get-LibraryFolder -Name $name) | Out-Null
        ($folders | Where-Object ResolvedPath -eq $a).IsDefaultSaveLocation | Should -BeTrue
    }

    It 'fails without -Merge when the library exists' {
        { Import-Library -Path $json -ErrorAction Stop } | Should -Throw '*already exists*'
    }

    It 'is idempotent with -Merge' {
        Import-Library -Path $json -Merge -WarningAction SilentlyContinue | Out-Null
        @(Get-LibraryFolder -Name $name).Count | Should -Be 2
    }
}
