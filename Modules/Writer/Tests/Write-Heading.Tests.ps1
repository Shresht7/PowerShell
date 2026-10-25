Describe 'Write-Heading' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\Write-Heading.ps1')
    }

    It 'writes a heading with a line below it' {
        $output = @(Write-Heading 'Hello' 6>&1)

        $output | Should -Be @(
            'Hello'
            '====='
        )
    }

    It 'uses a custom character' {
        $output = @(Write-Heading 'Hello' -Character '*' 6>&1)

        $output | Should -Be @(
            'Hello'
            '*****'
        )
    }

    It 'uses an explicit width' {
        $output = @(Write-Heading 'Hello' -Width 10 6>&1)

        $output | Should -Be @(
            'Hello'
            '=========='
        )
    }

    It 'uppercases the heading' {
        $output = @(Write-Heading 'Hello' -Uppercase 6>&1)

        $output | Should -Be @(
            'HELLO'
            '====='
        )
    }

    It 'writes a line above and below the heading with Double' {
        $output = @(Write-Heading 'Hello' -Double 6>&1)

        $output | Should -Be @(
            '====='
            'Hello'
            '====='
        )
    }

    It 'supports pipeline input' {
        $output = @('Hello' | Write-Heading 6>&1)

        $output | Should -Be @(
            'Hello'
            '====='
        )
    }

    It 'rejects a width of zero' {
        {
            Write-Heading 'Hello' -Width 0
        } | Should -Throw
    }
}
