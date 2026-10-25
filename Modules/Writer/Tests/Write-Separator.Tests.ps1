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

    It 'uses the specified width' {
        $output = Write-Separator -Character '*' -Width 4 6>&1
        $output | Should -Be '****'
    }

    It 'supports a multi-character separator pattern' {
        $output = Write-Separator -Character '-=' -Width 3 6>&1
        $output | Should -Be '-=-=-='
    }

}
