Describe 'Optimize-PSReadLineHistory' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'removes duplicates keeping last occurrence and trims to MaxLineCount' {
        $temp = Join-Path $env:TEMP 'psrl_history_optimize.txt'
        @('A', 'B', 'A', 'C', 'D') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            Optimize-PSReadLineHistory -MaxLineCount 3 -NoBackup
            (Get-Content -Path $temp) | Should -BeExactly @('A', 'C', 'D')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
