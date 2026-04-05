Describe 'Get-PSReadLineHistory' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'returns all commands from the history file' {
        $temp = Join-Path $env:TEMP 'psrl_history_all.txt'
        @(
            'Get-Process'
            'Get-Process'
            'Write-Output Hello'
            'Write-Output Hello'
            'Get-ChildItem'
        ) | Out-File -FilePath $temp -Encoding UTF8

        $env:PSREADLINE_HISTORY_PATH = $temp

        try {
            $history = Get-PSReadLineHistory
            $history | Should -BeExactly @( 'Get-Process', 'Get-Process', 'Write-Output Hello', 'Write-Output Hello', 'Get-ChildItem' )
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'supports -Unique to filter duplicates (keeps first occurrence)' {
        $temp = Join-Path $env:TEMP 'psrl_history_unique.txt'
        @(
            'A'
            'B'
            'A'
            'C'
            'B'
        ) | Out-File -FilePath $temp -Encoding UTF8

        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $unique = Get-PSReadLineHistory -Unique
            $unique | Should -BeExactly @('A', 'B', 'C')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'supports -Filter to return matching commands only' {
        $temp = Join-Path $env:TEMP 'psrl_history_filter.txt'
        @(
            'Get-Process'
            'Write-Output Hello'
            'Get-Service'
        ) | Out-File -FilePath $temp -Encoding UTF8

        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            (Get-PSReadLineHistory -Filter 'Get') | Should -BeExactly @('Get-Process', 'Get-Service')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}

Describe 'Get-PSReadLineHistory -Raw and multiline handling' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Private\Test-CommandComplete.ps1')
        Get-ChildItem -Path (Join-Path $moduleRoot 'Library') -Filter '*.ps1' | ForEach-Object { . $_.FullName }
    }

    It 'returns raw contents when -Raw is used' {
        $temp = Join-Path $env:TEMP 'psrl_raw.txt'
        @('line1', 'line2') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            (Get-PSReadLineHistory -Raw) | Should -Match 'line1'
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'reassembles multi-line commands from backtick continuations' {
        $temp = Join-Path $env:TEMP 'psrl_multiline.txt'
        # Write file in PSReadLine's backtick continuation format
        @(
            'Get-Process'
            'if ($true) {`'
            '    Write-Host "yes"`'
            '}'
            'Get-Service'
        ) | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $history = Get-PSReadLineHistory
            $history | Should -HaveCount 3
            $history[0] | Should -Be 'Get-Process'
            $history[1] | Should -Be "if (`$true) {`n    Write-Host ""yes""`n}"
            $history[2] | Should -Be 'Get-Service'
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'treats lines without trailing backtick as separate commands' {
        $temp = Join-Path $env:TEMP 'psrl_no_continuation.txt'
        @('Write-Output "hello', 'world"', 'Get-Process') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $history = Get-PSReadLineHistory
            # No backtick continuations, so each line is a separate command
            $history | Should -BeExactly @('Write-Output "hello', 'world"', 'Get-Process')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'handles commands with PowerShell line continuation backticks (double backtick in file)' {
        $temp = Join-Path $env:TEMP 'psrl_double_backtick.txt'
        # A command like: Get-Process `\n  -Name "code"
        # In the file, the original backtick + continuation backtick = double backtick
        @(
            'Get-Process ``'
            '  -Name "code"'
        ) | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $history = @(Get-PSReadLineHistory)
            $history | Should -HaveCount 1
            # First line had trailing backtick (continuation marker) stripped,
            # leaving the original backtick from the PowerShell line continuation
            $expected = 'Get-Process `' + "`n" + '  -Name "code"'
            $history[0] | Should -Be $expected
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }

    It 'roundtrips multi-line commands through Set and Get' {
        $temp = Join-Path $env:TEMP 'psrl_roundtrip.txt'
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $original = @(
                'simple-command'
                "foreach (`$item in `$list) {`n    Write-Host `$item`n}"
                "Get-Process ```n  | Where-Object { `$_.CPU -gt 100 }"
            )
            $original | Set-PSReadLineHistory -NoBackup
            $read = Get-PSReadLineHistory
            $read | Should -HaveCount $original.Count
            for ($i = 0; $i -lt $original.Count; $i++) {
                $read[$i] | Should -Be $original[$i]
            }
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
