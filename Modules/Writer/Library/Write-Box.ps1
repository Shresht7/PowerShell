function Write-Box {

    [CmdletBinding()]
    param(
        # Text to display in the box
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]] $Text,

        # Padding inside the box (default: 1)
        [ValidateRange(0, [uint32]::MaxValue)]
        [uint32] $Padding = 1,

        # Box style [Ascii, Single, Rounded] (default: Single)
        [ValidateSet("Ascii", "Single", "Rounded")]
        [string] $Style = 'Single'
    )

    begin {
        $Lines = [System.Collections.Generic.List[string]]::new()
        $Borders = @{
            Ascii   = @('+', '-', '+', '|', '+', '+')
            Single  = @('┌', '─', '┐', '│', '└', '┘')
            Rounded = @('╭', '─', '╮', '│', '╰', '╯')
        }
    }

    process {
        foreach ($Line in $Text) {
            $Lines.Add($Line)
        }
    }

    end {
        $Border = $Borders[$Style]
        $Width = ($Lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
        $InnerWidth = $Width + ($Padding * 2)

        Write-Host ($Border[0] + ($Border[1] * $InnerWidth) + $Border[2])

        foreach ($Line in $Lines) {
            $Content = $Line.PadRight($Width)
            Write-Host($Border[3] + (' ' * $Padding) + $Content + (' ' * $Padding) + $Border[3])
        }

        Write-Host ($Border[4] + ($Border[1] * $InnerWidth) + $Border[5])
    }

}
