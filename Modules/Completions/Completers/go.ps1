$script:GoTopLevelCommands = @(
    @{ Name = 'help'; Tooltip = 'show help' }
    @{ Name = 'bug'; Tooltip = 'start a bug report' }
    @{ Name = 'build'; Tooltip = 'compile packages and dependencies' }
    @{ Name = 'clean'; Tooltip = 'remove object files and cached files' }
    @{ Name = 'doc'; Tooltip = 'show documentation for package or symbol' }
    @{ Name = 'env'; Tooltip = 'print Go environment information' }
    @{ Name = 'fix'; Tooltip = 'apply fixes suggested by static checkers' }
    @{ Name = 'fmt'; Tooltip = 'gofmt (reformat) package sources' }
    @{ Name = 'generate'; Tooltip = 'generate Go files by processing source' }
    @{ Name = 'get'; Tooltip = 'add dependencies to current module and install them' }
    @{ Name = 'install'; Tooltip = 'compile and install packages and dependencies' }
    @{ Name = 'list'; Tooltip = 'list packages or modules' }
    @{ Name = 'mod'; Tooltip = 'module maintenance' }
    @{ Name = 'work'; Tooltip = 'workspace maintenance' }
    @{ Name = 'run'; Tooltip = 'compile and run Go program' }
    @{ Name = 'telemetry'; Tooltip = 'manage telemetry data and settings' }
    @{ Name = 'test'; Tooltip = 'test packages' }
    @{ Name = 'tool'; Tooltip = 'run specified go tool' }
    @{ Name = 'version'; Tooltip = 'print Go version' }
    @{ Name = 'vet'; Tooltip = 'report likely mistakes in packages' }
)

Register-ArgumentCompleter -Native -CommandName go -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # TOP LEVEL COMMANDS
    $script:GoTopLevelCommands |
    Where-Object { $_.Name -like "$wordToComplete*" } |
    ForEach-Object {
        [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
    }
}
