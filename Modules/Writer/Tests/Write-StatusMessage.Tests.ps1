Describe 'Write-StatusMessage' {
    BeforeAll {
        $moduleRoot = Split-Path -Parent $PSScriptRoot
        . (Join-Path $moduleRoot 'Library\Write-StatusMessage.ps1')
    }

    It 'uses INFO as the default status' {
        $output = @(Write-StatusMessage 'Starting' -MessageColor '' 6>&1)

        $output | Should -Be "$($PSStyle.Foreground.Cyan)[INFO]$($PSStyle.Reset) Starting"
    }

    It 'allows custom status text' {
        $output = @(Write-StatusMessage 'Complete' -Status 'DONE' -StatusColor '' -MessageColor '' 6>&1)

        $output | Should -Be '[DONE] Complete'
    }

    It 'uses the standard fallback color for status names' {
        $statuses = @{
            ERROR    = $PSStyle.Foreground.Red
            WARN     = $PSStyle.Foreground.Yellow
            WARNING  = $PSStyle.Foreground.Yellow
            CRITICAL = "$($PSStyle.Foreground.Red)$($PSStyle.Bold)"
            SUCCESS  = $PSStyle.Foreground.Green
            OK       = $PSStyle.Foreground.Green
        }

        foreach ($Status in $statuses.Keys) {
            $output = @(Write-StatusMessage 'Message' -Status $Status -MessageColor '' 6>&1)

            $output | Should -Be "$($statuses[$Status])[$Status]$($PSStyle.Reset) Message"
        }
    }

    It 'styles the status and message independently' {
        $output = @(Write-StatusMessage 'Complete' -Status 'DONE' -StatusColor '<status>' -MessageColor '<message>' 6>&1)

        $output | Should -Be ("<status>[DONE]$([char]27)[0m <message>Complete$([char]27)[0m")
    }

    It 'accepts pipeline input' {
        $output = @('First', 'Second') | Write-StatusMessage -StatusColor '' -MessageColor '' 6>&1

        $output | Should -Be @(
            '[INFO] First'
            '[INFO] Second'
        )
    }
}
