Describe 'Export-Library' {
    BeforeAll {
        $librariesRoot = Split-Path -Parent $PSScriptRoot
        $publicRoot = Join-Path $librariesRoot 'Public'
        . (Join-Path $publicRoot 'Export-Library.ps1')

        $xml = @'
<libraryDescription Name="Test Library" ownerSID="S-1-5-21" Version="6.0">
  <isLibraryPinned>true</isLibraryPinned>
  <templateInfo><folderType>{7d49d726-3c21-4f05-99aa-fdc2c9474656}</folderType></templateInfo>
  <searchConnectorDescriptionList>
    <searchConnectorDescription>
      <isDefaultSaveLocation>true</isDefaultSaveLocation>
      <simpleLocation><url>C:\Documents</url></simpleLocation>
    </searchConnectorDescription>
  </searchConnectorDescriptionList>
</libraryDescription>
'@

        function Get-LibraryFile {
            [pscustomobject]@{ BaseName = 'Test Library'; FullName = 'C:\Test Library.library-ms' }
        }

        function Read-LibraryDefinition {
            [xml] $xml
        }
    }

    It 'returns the library definition when no path is supplied' {
        $result = Export-Library -Name 'Test Library'

        $result.Name | Should -Be 'Test Library'
        $result.IsPinned | Should -BeTrue
        $result.Locations.URL | Should -Be 'C:\Documents'
    }

    It 'writes JSON to a literal path' {
        $path = Join-Path $TestDrive 'library export.json'

        $result = Export-Library -Name 'Test Library' -Path $path

        $result.Name | Should -Be 'library export.json'
        (Get-Content -LiteralPath $path -Raw | ConvertFrom-Json).Name | Should -Be 'Test Library'
    }

    It 'rejects overwriting without Force' {
        $path = Join-Path $TestDrive 'existing.json'
        Set-Content -LiteralPath $path -Value 'existing'

        { Export-Library -Name 'Test Library' -Path $path } |
            Should -Throw '*already exists*'
    }

    It 'supports Force when overwriting' {
        $path = Join-Path $TestDrive 'force.json'
        Set-Content -LiteralPath $path -Value 'existing'

        Export-Library -Name 'Test Library' -Path $path -Force | Out-Null

        (Get-Content -LiteralPath $path -Raw | ConvertFrom-Json).Name | Should -Be 'Test Library'
    }

    It 'supports WhatIf without writing' {
        $path = Join-Path $TestDrive 'whatif.json'

        Export-Library -Name 'Test Library' -Path $path -WhatIf | Should -BeNullOrEmpty

        Test-Path -LiteralPath $path | Should -BeFalse
    }
}
