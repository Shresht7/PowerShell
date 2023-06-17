<#
.SYNOPSIS
    Measures the size of the given path.
.DESCRIPTION
    The Get-Size cmdlet measures the size of the given path and returns information about its size in different units.
.PARAMETER Path
    Specifies the path for which to measure the size. If not specified, the current directory is used.
.PARAMETER Recurse
    Indicates whether to recursively measure the size of the path, including subdirectories.
.EXAMPLE
    Get-Size
    Measures the size of the current directory.
.EXAMPLE
    Get-Size -Recurse
    Measures the size of the current directory by recursing into subdirectories.
#>
function Get-Size(
    # Specifies the path for which to measure the size. If not specified, the current directory is used.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string[]]$Path = "."
) {

    Process {
        foreach ($Item in $Path) {
            $ItemObject = Get-Item $Item

            # If the Item is a directory
            if ($ItemObject.PSIsContainer) {
                $Files = Get-ChildItem -Path $Item -File -Recurse
                $Size = $Files | Measure-Object -Sum Length

                [PSCustomObject]@{
                    Name      = $ItemObject.Name
                    Path      = $ItemObject.FullName
                    Files     = $Files.Count
                    Size      = $Size.Sum
                    Bytes     = $Size.Sum
                    Kilobytes = $Size.Sum / 1Kb
                    Megabytes = $Size.Sum / 1Mb
                    Gigabytes = $Size.Sum / 1Gb
                }
            }
            # Else if the item is a file
            else {
                [PSCustomObject]@{
                    Name      = $ItemObject.Name
                    Path      = $ItemObject.FullName
                    Size      = $ItemObject.Length
                    Bytes     = $ItemObject.Length
                    Kilobytes = $ItemObject.Length / 1Kb
                    Megabytes = $ItemObject.Length / 1Mb
                    Gigabytes = $ItemObject.Length / 1Gb
                }
            }
        }
    }
}
