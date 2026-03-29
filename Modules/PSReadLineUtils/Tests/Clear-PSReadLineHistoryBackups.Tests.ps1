Describe 'Clear-PSReadLineHistoryBackups' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'removes old backups and keeps the specified number' {
        $dir = Join-Path $env:TEMP 'psrl_backups'
        New-Item -Path $dir -ItemType Directory -Force | Out-Null

        # Use a history filename that does not include an underscore-prefix to avoid
        # accidentally matching the backup pattern when listing backups.
        $history = Join-Path $dir 'myhistory.txt'
        'x' | Out-File -FilePath $history -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $history

        # create four backup files matching the pattern myhistory_*
        1..4 | ForEach-Object { New-Item -Path (Join-Path $dir ("myhistory_{0}.txt" -f $_)) -ItemType File -Force | Out-Null }

        try {
            $initial = (Get-ChildItem -Path $dir -Filter 'myhistory_*' -File).Count
            $removed = Clear-PSReadLineHistoryBackups -Keep 2
            $remaining = (Get-ChildItem -Path $dir -Filter 'myhistory_*' -File).Count

            # After pruning, no more than Keep files should remain, and removed should match the difference
            $remaining | Should -BeLessOrEqual 2
            $removed | Should -Be ($initial - $remaining)
        }
        finally {
            Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
