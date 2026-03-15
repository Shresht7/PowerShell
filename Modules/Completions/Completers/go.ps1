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
    @{ Name = 'mod'; Tooltip = 'module maintenance'; Completions = @(
            @{ Name = 'download'; Tooltip = 'download modules to local cache' }
            @{ Name = 'edit'; Tooltip = 'edit go.mod from tools or scripts' }
            @{ Name = 'graph'; Tooltip = 'print module requirement graph' }
            @{ Name = 'init'; Tooltip = 'initialize new module in current directory' }
            @{ Name = 'tidy'; Tooltip = 'add missing and remove unused modules' }
            @{ Name = 'vendor'; Tooltip = 'make vendored copy of dependencies' }
            @{ Name = 'verify'; Tooltip = 'verify dependencies have expected content' }
            @{ Name = 'why'; Tooltip = 'explain why packages or modules are needed' }
        )
    }
    @{ Name = 'work'; Tooltip = 'workspace maintenance' }
    @{ Name = 'run'; Tooltip = 'compile and run Go program' }
    @{ Name = 'telemetry'; Tooltip = 'manage telemetry data and settings' }
    @{ Name = 'test'; Tooltip = 'test packages' }
    @{ Name = 'tool'; Tooltip = 'run specified go tool' }
    @{ Name = 'version'; Tooltip = 'print Go version' }
    @{ Name = 'vet'; Tooltip = 'report likely mistakes in packages' }
)

$script:GoHelpTopics = @(
    @{ Name = 'buildconstraint'; Tooltip = 'build constraints' }
    @{ Name = 'buildjson'; Tooltip = 'build -json encoding' }
    @{ Name = 'buildmode'; Tooltip = 'build modes' }
    @{ Name = 'c'; Tooltip = 'calling between Go and C' }
    @{ Name = 'cache'; Tooltip = 'build and test caching' }
    @{ Name = 'environment'; Tooltip = 'environment variables' }
    @{ Name = 'filetype'; Tooltip = 'file types' }
    @{ Name = 'goauth'; Tooltip = 'GOAUTH environment variable' }
    @{ Name = 'go.mod'; Tooltip = 'the go.mod file' }
    @{ Name = 'gopath'; Tooltip = 'GOPATH environment variable' }
    @{ Name = 'goproxy'; Tooltip = 'module proxy protocol' }
    @{ Name = 'importpath'; Tooltip = 'import path syntax' }
    @{ Name = 'modules'; Tooltip = 'modules, module versions, and more' }
    @{ Name = 'module-auth'; Tooltip = 'module authentication using go.sum' }
    @{ Name = 'packages'; Tooltip = 'package lists and patterns' }
    @{ Name = 'private'; Tooltip = 'configuration for downloading non-public code' }
    @{ Name = 'testflag'; Tooltip = 'testing flags' }
    @{ Name = 'testfunc'; Tooltip = 'testing functions' }
    @{ Name = 'vcs'; Tooltip = 'controlling version control with GOVCS' }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName go -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # Get the command elements as text (e.g. 'go', 'help', 'buildconstraint', etc.)
    $elements = @($commandAst.CommandElements | ForEach-Object { $_.Extent.Text })

    # HELP TOPICS
    if ($elements.Count -ge 2 -and $elements[1] -eq 'help') {
        @($script:GoTopLevelCommands + $script:GoHelpTopics) |
        Where-Object { $_.Name -like "$wordToComplete*" } |
        ForEach-Object {
            [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
        }
        return
    }

    # SUBCOMMANDS
    if ($elements.Count -ge 2) {
        $parent = $script:GoTopLevelCommands | Where-Object { $_.Name -eq $elements[1] } | Select-Object -First 1
        if ($null -ne $parent -and $null -ne $parent.Completions) {
            $parent.Completions |
            Where-Object { $_.Name -like "$wordToComplete*" } |
            ForEach-Object {
                [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
            }
            return
        }
    }

    # TOP LEVEL COMMANDS
    $script:GoTopLevelCommands |
    Where-Object { $_.Name -like "$wordToComplete*" } |
    ForEach-Object {
        [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
    }
}
