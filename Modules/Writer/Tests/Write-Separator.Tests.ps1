Describe "Write-Separator Parameter Validation" {

    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\Write-Separator.ps1')
    }

    It 'rejects a width of 0' {
        { Write-Separator -Width 0 } | Should -Throw
    }

    It 'accepts a width of 1' {
        { Write-Separator -Width 1 } | Should -Not -Throw
    }

}
