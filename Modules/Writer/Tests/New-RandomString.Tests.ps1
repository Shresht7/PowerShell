Describe 'New-RandomString Validation' {

    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\New-RandomString.ps1')
    }

    It 'rejects an empty character set' {
        { New-RandomString -Length 5 -Characters '' } | Should -Throw
    }

    It 'generates the requested number of characters' {
        $result = New-RandomString -Length 1000 -Characters 'abc'
        $result.ToCharArray() | Should -HaveCount 1000
    }

    It 'generates characters from the supplied character set' {
        $result = New-RandomString -Length 20 -Characters 'abc'
        $result.ToCharArray() | Should -HaveCount 20
        [System.Collections.Generic.HashSet[string]] $chars = [System.Collections.Generic.HashSet[string]]::new()
        $result.ToCharArray() | ForEach-Object { $chars.Add($_) }
        $chars | Should -Contain 'a'
        $chars | Should -Contain 'b'
        $chars | Should -Contain 'c'
    }

    It 'returns an empty string for a length of zero' {
        $result = New-RandomString -Length 0 -Characters 'abc'
        $result | Should -Be ''
    }

}
