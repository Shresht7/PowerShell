Describe "Write-TypeWriter Parameter Validation" {

    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot "Library\Write-TypeWriter.ps1")
    }

    It 'rejects a CPM of 0' {
        { Write-TypeWriter -CPM 0 } | Should -Throw
    }

    It 'rejects a speed of 0' {
        { Write-TypeWriter -Speed 0 } | Should -Throw
    }

    It 'accepts a CPM of 1' {
        { Write-TypeWriter -CPM 1 -Text '' } | Should -Not -Throw
    }

    It 'accepts a speed of 1' {
        { Write-TypeWriter -Speed 1 -Text '' } | Should -Not -Throw
    }

}
