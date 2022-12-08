Import-Module -Name Writer

Describe "Get-ReversedString" {
    Context ": When a string is passed" {
        It "Should return the reversed string" {
            Get-ReversedString -String "Hello" | Should Be "olleH"
        }
        It "Should return the original string when reversed twice" {
            $String = "Text"
            Get-ReversedString (Get-ReversedString $String) | Should Be $String
        }
        It "Should accept a string from the pipeline" {
            "PipeLine" | Get-ReversedString | Should Be "eniLepiP"
        }
        It "Should take remaining arguments as value" {
            Get-ReversedString this is one string | Should Be "gnirts eno si siht"
        }
    }
    Context ": When a number is passed" {
        It "Should return the reversed string" {
            Get-ReversedString -String 123 | Should Be 321
        }
    }
}
