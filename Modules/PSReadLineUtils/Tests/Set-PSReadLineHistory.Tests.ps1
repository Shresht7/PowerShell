Describe 'Set-PSReadLineHistory' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'overwrites the history file with provided content' {
        $temp = Join-Path $env:TEMP 'psrl_history_set.txt'
        @('old1', 'old2') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            @('new1', 'new2', 'new3') | Set-PSReadLineHistory -NoBackup
            (Get-PSReadLineHistory) | Should -BeExactly @('new1', 'new2', 'new3')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'encodes multi-line commands with backtick continuations' {
        $temp = Join-Path $env:TEMP 'psrl_history_set_multiline.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $multiline = "if (`$true) {`n    Write-Host 'yes'`n}"
            @('A', $multiline, 'B') | Set-PSReadLineHistory -NoBackup

            # The file should encode newlines as backtick + newline
            $raw = Get-Content -Path $temp
            $raw | Should -Contain 'if ($true) {`'
            $raw | Should -Contain "    Write-Host 'yes'``"

            # Roundtrip: read back should match original commands
            $read = Get-PSReadLineHistory
            $read | Should -HaveCount 3
            $read[0] | Should -Be 'A'
            $read[1] | Should -Be $multiline
            $read[2] | Should -Be 'B'
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'collects all pipeline items instead of overwriting' {
        $temp = Join-Path $env:TEMP 'psrl_history_set_pipeline.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            @('A', 'B', 'C') | Set-PSReadLineHistory -NoBackup
            (Get-PSReadLineHistory) | Should -BeExactly @('A', 'B', 'C')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'appends when -Append is used' {
        $temp = Join-Path $env:TEMP 'psrl_history_set_append.txt'
        @('start') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            'appended' | Set-PSReadLineHistory -Append -NoBackup
            (Get-Content -Path $temp) | Should -BeExactly @('start', 'appended')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
