<#
.SYNOPSIS
    Register a command completer
.DESCRIPTION
    Register a command completer.
    The script block starts by tracking the current command selection in the $COMMANDS tree object,
    then filters the completions that match the word to complete and returns them as CompletionResult objects.
.EXAMPLE
    Register-CommandCompleter -Name npm -Tooltip "Node Package Manager" -Completions @(
        New-Completion -Name 'install' -Tooltip 'Install a package' -Completions @(
            New-Completion -Name '-g' -Tooltip 'Save as a global dependency'
            New-Completion -Name '--global' -Tooltip 'Save as a global dependency'
            New-Completion -Name '--save-dev' -Tooltip 'Save as dev-dependency'
        )
        New-Completion -Name "uninstall" -Tooltip "Uninstall a package"
    )
#>
function Register-CommandCompleter(
    # The name of the command
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
    [Alias('Command', 'CommandName')]
    [string] $Name,

    # The tooltip to display
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('Description', 'Help', 'HelpText', 'HelpMessage', 'Message')]
    [string] $Tooltip,

    # The completions object
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('Next', 'NextCompletions', 'SubCompletions')]
    [Completion[]] $Completions
) {
    # Add Command to the Global $COMMANDS tree object
    $SuperCommand = New-Completion -Name $Name -Tooltip $Tooltip -Completions $Completions
    $Script:COMMANDS.Completions += $SuperCommand
    
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
            $Selection = $Selection.Completions | Where-Object { $_.Name -Like $SubCommand }
            # Make use of the script block to generate the next selection, if any
            if ($null -ne $Selection.CompletionsScriptBlock) {
                $Selection.Completions += $Selection.CompletionsScriptBlock.Invoke()
            }
        }

        # Filter the completions that match the word to complete
        $Completions = $Selection.Completions | ForEach-Object {
            if ($_.Name -Like "*${wordToComplete}*") {
                # Create a new CompletionResult object to return
                [CompletionResult]::new($_.Name, $_.Name, $_.Type, $_.Tooltip)
            }
        }

        # Return the completions
        return $Completions
    }
}
