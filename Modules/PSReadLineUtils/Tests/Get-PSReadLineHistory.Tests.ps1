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

    It 'returns file lines as history entries (parser-dependent behavior)' {
        $temp = Join-Path $env:TEMP 'psrl_multiline.txt'
        @('Write-Output "hello', 'world"', 'Get-Process') | Out-File -FilePath $temp -Encoding UTF8
        $env:PSREADLINE_HISTORY_PATH = $temp
        try {
            $history = Get-PSReadLineHistory
            # Parser behavior can vary by PowerShell version; assert the function returns the raw lines as entries
            $history | Should -BeExactly @('Write-Output "hello', 'world"', 'Get-Process')
        }
        finally {
            Remove-Item -Path $temp -ErrorAction SilentlyContinue
            Remove-Item Env:PSREADLINE_HISTORY_PATH -ErrorAction SilentlyContinue
        }
    }
}
