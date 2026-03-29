Describe 'Remove-PSReadLineHistoryItem' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'removes specific command occurrences' {
        $temp = Join-Path $env:TEMP 'psrl_history_remove_cmd.txt'
        @('A', 'B', 'A', 'C') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            Remove-PSReadLineHistoryItem -Command 'A' -NoBackup
            (Get-Content -Path $temp) | Should -BeExactly @('B', 'C')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'removes last N items when -Count is used' {
        $temp = Join-Path $env:TEMP 'psrl_history_remove_count.txt'
        @('1', '2', '3', '4') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            Remove-PSReadLineHistoryItem -Count 2 -NoBackup
            (Get-Content -Path $temp) | Should -BeExactly @('1', '2')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'removes duplicates when -Duplicate is used' {
        $temp = Join-Path $env:TEMP 'psrl_history_remove_dup.txt'
        @('A', 'A', 'B', 'B') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            Remove-PSReadLineHistoryItem -Duplicate -NoBackup
            (Get-Content -Path $temp) | Should -BeExactly @('A', 'B')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
