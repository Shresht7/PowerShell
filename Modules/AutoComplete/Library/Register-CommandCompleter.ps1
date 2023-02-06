# Commands Global
$Script:COMMANDS = @{'Next' = [System.Collections.ArrayList]::new() }

<#
.SYNOPSIS
    Register a command completer
.DESCRIPTION
    Register a command completer.
    The script block starts by tracking the current command selection in the $COMMANDS tree object,
    then filters the completions that match the word to complete and returns them as CompletionResult objects.
.EXAMPLE
    Register-CommandCompleter -Name 'git' -Tooltip 'git source control' -Completions @(
        [Completion]::new('add', 'Add file contents to the index'),
        [Completion]::new('branch', 'List, create, or delete branches', @(
            [Completion]::new('-a', 'List both remote-tracking branches and local branches'),
            [Completion]::new('-d', 'Delete fully merged branch'),
            [Completion]::new('-D', 'Delete branch (even if not merged)'),
        )),
    )
#>
function Register-CommandCompleter(
    # The name of the command
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Command')]
    [string] $Name,

    # The tooltip to display
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
    [string] $Tooltip,

    # The completions object
    [Completion[]] $Completions
) {
    # Add Command to the Global $COMMANDS tree object
    $SuperCommand = New-Completion -Name $Name -Tooltip $Tooltip -Next $Completions
    $null = $Script:COMMANDS.Next.Add($SuperCommand)
    
    # Register Auto-Complete Arguments
    Register-ArgumentCompleter -CommandName $Name -ScriptBlock {
        param($WordToComplete, $CommandAST, $CursorPosition)

        # Filter out non-command elements
        $Command = @(
            foreach ($Element in $CommandAST.CommandElements) {
                # Ignore string constants and parameters
                if (
                    $Element -isNot [Language.StringConstantExpressionAst] -or
                    $Element.StringConstantType -ne [Language.StringConstantType]::BareWord -or
                    $Element.Value.StartsWith('-') -or
                    $Element.Value -eq $WordToComplete
                ) { break }
                # Return only commands
                $Element.Value
            }
        )

        # Track the current command selection
        $Selection = $Script:COMMANDS
        foreach ($SubCommand in $Command) {
            # Find the next command in the tree object and set it as the current selection
            $Selection = $Selection.Next | Where-Object { $_.Name -Like $SubCommand }
            # Make use of the script block to generate the next selection, if any
            if ($null -ne $Selection.Script) {
                $Selection.Next += $Selection.Script.Invoke()
            }
        }

        # Filter the completions that match the word to complete
        $Completions = $Selection.Next | Where-Object { $_.Name -Like "${WordToComplete}*" } | ForEach-Object {
            # Create a new CompletionResult object to return
            [CompletionResult]::new($_.Name, $_.Name, $_.Type, $_.Tooltip)
        }

        # Return the completions
        return $Completions
    }
}
