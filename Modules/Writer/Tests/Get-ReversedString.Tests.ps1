Describe 'Get-ReversedString' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\Get-ReversedString.ps1')
    }

    It 'reverses an ASCII string' {
        Get-ReversedString 'Hello World!' |
        Should -Be '!dlroW olleH'
    }

    It 'accepts pipeline input' {
        '12345' | Get-ReversedString |
        Should -Be '54321'
    }

    It 'treats remaining arguments as one string' {
        Get-ReversedString this is all one string |
        Should -Be 'gnirts eno lla si siht'
    }

    It 'preserves surrogate pairs' {
        Get-ReversedString 'A😀B' |
        Should -Be 'B😀A'
    }

    It 'preserves combining characters' {
        $text = "A" + "e`u{301}" + "B"

        Get-ReversedString $text |
        Should -Be ("B" + "e`u{301}" + "A")
    }
}
