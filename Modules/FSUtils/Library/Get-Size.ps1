<#
.SYNOPSIS
    Get size of the given path
.DESCRIPTION
    Measures the size of the given path
.PARAMETER $Path
    Path to measure the size of
.PARAMETER $Recurse
    Recursively measure the size of the path
.EXAMPLE
    Get-Size
    Get the size of the current directory
.EXAMPLE
    Get-Size -Recurse
    Get the size of the current directory by recursing into sub-directories
#>
function Get-Size(
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string[]]$Path = "."
) {
    Begin {
        $Output = [System.Collections.ArrayList]::new()
    }
    Process {
        $Item = Get-Item $Path
        
        # If the Item is a directory
        if ($Item.PSIsContainer) {
            $null = $Output.Add(($Item | Get-ChildItem -Recurse | Measure-Object -Sum Length | Select-Object `
                    @{Name = "Name"; Expression = { $Item.Name } },
                    @{Name = "Path"; Expression = { $Item.FullName } },
                    @{Name = "Files"; Expression = { $_.Count } },
                    @{Name = "Size"; Expression = { $_.Sum } },
                    @{Name = "Bytes"; Expression = { $_.Sum } },
                    @{Name = "Kilobytes"; Expression = { $_.Sum / 1Kb } },
                    @{Name = "Megabytes"; Expression = { $_.Sum / 1Mb } },
                    @{Name = "Gigabytes"; Expression = { $_.Sum / 1Gb } }
                ))
        }
        # Else if the item is a file
        else {
            $null = $Output.Add(($Item | Select-Object `
                    @{Name = "Name"; Expression = { $Item.Name } },
                    @{Name = "Path"; Expression = { $Item.FullName } },
                    @{Name = "Size"; Expression = { $_.Length } },
                    @{Name = "Bytes"; Expression = { $_.Length } },
                    @{Name = "Kilobytes"; Expression = { $_.Length / 1Kb } },
                    @{Name = "Megabytes"; Expression = { $_.Length / 1Mb } },
                    @{Name = "Gigabytes"; Expression = { $_.Length / 1Gb } }
                ))
        }
    }
    End {
        return $Output
    }
}
