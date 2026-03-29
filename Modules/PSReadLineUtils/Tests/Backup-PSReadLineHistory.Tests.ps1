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

Describe 'Backup-PSReadLineHistory with -Keep' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'creates a backup and prunes old backups when -Keep is specified' {
        $dir = Join-Path $env:TEMP 'psrl_backup_keep'
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
        $history = Join-Path $dir 'h.txt'
        'x' | Out-File -FilePath $history -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $history

        # create three existing backups
        1..3 | ForEach-Object { New-Item -Path (Join-Path $dir ("h_{0}.txt" -f $_)) -ItemType File -Force | Out-Null }

        try {
            $out = Backup-PSReadLineHistory -Keep 2
            $backups = Get-ChildItem -Path $dir -Filter 'h_*' -File
            # After pruning, no more than Keep files should remain
            $backups.Count | Should -BeLessOrEqual 2
            # Ensure at least one backup exists (the function should create one)
            $backups.Count | Should -BeGreaterThan 0
        }
        finally {
            Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
