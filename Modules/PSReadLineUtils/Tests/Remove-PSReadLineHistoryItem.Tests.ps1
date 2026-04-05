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
            (Get-PSReadLineHistory) | Should -BeExactly @('B', 'C')
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
            (Get-PSReadLineHistory) | Should -BeExactly @('1', '2')
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
            (Get-PSReadLineHistory) | Should -BeExactly @('A', 'B')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Remove-PSReadLineHistoryItem - pipeline support' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'accepts piped command names to remove them from history' {
        $temp = Join-Path $env:TEMP 'psrl_history_pipe.txt'
        @('A', 'B', 'C') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            'B' | Remove-PSReadLineHistoryItem -NoBackup
            (Get-PSReadLineHistory) | Should -BeExactly @('A', 'C')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'removes multiple piped commands in a single operation' {
        $temp = Join-Path $env:TEMP 'psrl_history_pipe_multi.txt'
        @('A', 'B', 'C', 'D') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            @('B', 'D') | Remove-PSReadLineHistoryItem -NoBackup
            (Get-PSReadLineHistory) | Should -BeExactly @('A', 'C')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'removes multi-line commands from history' {
        $temp = Join-Path $env:TEMP 'psrl_history_remove_ml.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $multiline = "if (`$true) {`n    Write-Host 'yes'`n}"
            @('A', $multiline, 'B') | Set-PSReadLineHistory -NoBackup
            Remove-PSReadLineHistoryItem -Command $multiline -NoBackup
            (Get-PSReadLineHistory) | Should -BeExactly @('A', 'B')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
