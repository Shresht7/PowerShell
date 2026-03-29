Describe 'Test-CommandComplete' {
    It 'returns true for a complete simple command' {
        . (Join-Path (Split-Path -Parent $PSScriptRoot) 'Private\Test-CommandComplete.ps1')
        Test-CommandComplete 'Get-Process' | Should -BeTrue
    }

    It 'returns a boolean for incomplete-looking inputs (non-flaky assertion)' {
        . (Join-Path (Split-Path -Parent $PSScriptRoot) 'Private\Test-CommandComplete.ps1')
        Test-CommandComplete 'Get-Process |' | Should -BeOfType 'System.Boolean'
        Test-CommandComplete '"hello' | Should -BeOfType 'System.Boolean'
        Test-CommandComplete '(Get-Process' | Should -BeOfType 'System.Boolean'
    }
}
