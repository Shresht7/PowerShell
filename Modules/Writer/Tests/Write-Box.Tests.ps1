Describe 'Write-Box' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\Write-Box.ps1')
    }

    It 'writes a single-line ASCII box' {
        $output = @(Write-Box -Text 'Hello' -Style Ascii 6>&1)

        $output | Should -Be @(
            '+-------+'
            '| Hello |'
            '+-------+'
        )
    }

    It 'pads multiple lines to the longest line' {
        $output = @(Write-Box -Text @('Short', 'Longer') -Style Ascii 6>&1)

        $output | Should -Be @(
            '+--------+'
            '| Short  |'
            '| Longer |'
            '+--------+'
        )
    }

    It 'supports zero padding' {
        $output = @(Write-Box -Text 'Hello' -Padding 0 -Style Ascii 6>&1)

        $output | Should -Be @(
            '+-----+'
            '|Hello|'
            '+-----+'
        )
    }

    It 'supports pipeline input' {
        $output = @(
            'First'
            'Second'
        ) | Write-Box -Style Ascii 6>&1

        $output | Should -Be @(
            '+--------+'
            '| First  |'
            '| Second |'
            '+--------+'
        )
    }

    It 'rejects a negative padding value' {
        { Write-Box -Text 'Hello' -Padding -1 } | Should -Throw
    }
}
