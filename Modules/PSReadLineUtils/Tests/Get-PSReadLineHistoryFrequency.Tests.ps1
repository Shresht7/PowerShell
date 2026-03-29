Describe 'Get-PSReadLineHistoryFrequency' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'groups and counts commands correctly and returns top items' {
        $temp = Join-Path $env:TEMP 'psrl_history_freq.txt'
        @('A', 'B', 'A', 'C', 'A', 'B') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $freq = Get-PSReadLineHistoryFrequency
            $freq[0].Command | Should -Be 'A'
            $freq[0].Count | Should -Be 3

            # Ensure the reported count for command 'B' equals 2 (sum any matching groups)
            ($freq | Where-Object Command -eq 'B' | Measure-Object -Property Count -Sum).Sum | Should -Be 2

            $top2 = Get-PSReadLineHistoryFrequency -First 2
            $top2.Count | Should -Be 2

            $byName = Get-PSReadLineHistoryFrequency -SortBy 'Command'
            # Sorted descending by name: C,B,A
            $byName[0].Command | Should -Be 'C'
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Get-PSReadLineHistoryFrequency edge cases' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'returns empty when history file is empty' {
        $temp = Join-Path $env:TEMP 'psrl_freq_empty.txt'
        New-Item -Path $temp -ItemType File -Force | Out-Null
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            (Get-PSReadLineHistoryFrequency).Count | Should -Be 0
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'returns all items when -First is larger than available' {
        $temp = Join-Path $env:TEMP 'psrl_freq_small.txt'
        @('X', 'Y') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            (Get-PSReadLineHistoryFrequency -First 10).Count | Should -Be 2
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
