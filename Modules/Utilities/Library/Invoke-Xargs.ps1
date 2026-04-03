function Invoke-Xargs {

    [CmdletBinding()]
    param (
        # The command to execute, followed by any additional arguments
        [Parameter(Position = 0, ValueFromRemainingArguments)]
        [string]$Command,

        # The input objects to be passed as arguments to the command. 
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$InputObject
    )

    begin {
        # Initialize a list to hold the arguments that will be passed to the command
        $restArgs = [System.Collections.Generic.List[string]]::new()
    }

    process {
        # Collect the input objects and add them to the list of arguments
        foreach ($item in $InputObject) {
            [void] $restArgs.Add($item)
        }
    }

    end {
        # Construct the command with its arguments and execute it
        $commandWithArgs = "$Command " + ($restArgs -join ' ')
        Write-Verbose "Executing: $commandWithArgs"
        Invoke-Expression $commandWithArgs
    }

}

Set-Alias -Name xargs -Value Invoke-Xargs -Scope Global -Force
