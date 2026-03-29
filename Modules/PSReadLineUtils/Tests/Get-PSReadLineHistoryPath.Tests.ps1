Describe 'Get-PSReadLineHistoryPath' {
    BeforeAll {
        # Dot-source helpers and library functions (avoid importing the module which requires PSReadLine)
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'returns the file path when PSREADLINE_HISTORY_PATH is set' {
        $temp = Join-Path $env:TEMP 'psrl_test_history.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            (Get-PSReadLineHistoryPath -Type File) | Should -Be $temp
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'returns the directory when -Type Directory is specified' {
        $temp = Join-Path $env:TEMP 'psrl_test_history2.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            (Get-PSReadLineHistoryPath -Type Directory) | Should -Be (Split-Path $temp)
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
