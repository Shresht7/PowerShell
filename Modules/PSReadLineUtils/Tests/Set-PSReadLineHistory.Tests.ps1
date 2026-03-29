Describe 'Set-PSReadLineHistory' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'overwrites the history file with provided content' {
        $temp = Join-Path $env:TEMP 'psrl_history_set.txt'
        # create an initial file
        @('old1', 'old2') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $text = "new1`nnew2`nnew3"
            Set-PSReadLineHistory -Content $text -NoBackup
            (Get-Content -Path $temp -Raw) | Should -Match 'new1'
            (Get-Content -Path $temp) | Should -BeExactly @('new1', 'new2', 'new3')
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
