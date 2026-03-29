Describe 'Backup-PSReadLineHistory' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'creates a backup at the specified destination' {
        $temp = Join-Path $env:TEMP 'psrl_history_backup_src.txt'
        $dest = Join-Path $env:TEMP 'psrl_history_backup_dest.txt'
        'line1' | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $out = Backup-PSReadLineHistory -Destination $dest
            Test-Path $out | Should -BeTrue
            (Get-Content -Path $out) | Should -BeExactly @('line1')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item -Path $dest -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
