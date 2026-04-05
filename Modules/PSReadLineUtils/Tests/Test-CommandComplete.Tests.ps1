Describe 'Test-CommandComplete' {
    BeforeAll {
        . (Join-Path (Split-Path -Parent $PSScriptRoot) 'Private\Test-CommandComplete.ps1')
    }

    It 'returns true for a complete simple command' {
        Test-CommandComplete 'Get-Process' | Should -BeTrue
    }

    It 'returns true for a complete multi-statement command' {
        Test-CommandComplete 'Get-Process; Get-Service' | Should -BeTrue
    }

    It 'returns true for a complete variable reference' {
        Test-CommandComplete '$var' | Should -BeTrue
    }

    It 'returns true for a syntactically invalid but complete command' {
        Test-CommandComplete 'Get-Process -InvalidParam @@@@' | Should -BeTrue
    }

    It 'returns false for a trailing pipe operator' {
        Test-CommandComplete 'Get-Process |' | Should -BeFalse
    }

    It 'returns false for an unclosed string' {
        Test-CommandComplete '"hello' | Should -BeFalse
    }

    It 'returns false for an unclosed parenthesis' {
        Test-CommandComplete '(Get-Process' | Should -BeFalse
    }

    It 'returns false for an unclosed brace' {
        Test-CommandComplete 'if ($true) {' | Should -BeFalse
    }

    It 'returns false for an unclosed here-string' {
        Test-CommandComplete '@"' | Should -BeFalse
    }

    It 'returns true for a complete multi-line command' {
        Test-CommandComplete "if (`$true) {`n    Write-Host 'yes'`n}" | Should -BeTrue
    }

    It 'returns true for an empty or whitespace string' {
        Test-CommandComplete '' | Should -BeTrue
        Test-CommandComplete '   ' | Should -BeTrue
    }
}
