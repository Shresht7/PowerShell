# Requires-Module AutoComplete

# TODO: Add the remaining commands as needed

Register-CommandCompleter -Name go -Tooltip 'Go Command-Line-Interface' -Completions @(
    New-Completion -Name 'help' -Tooltip 'get help'
    New-Completion -Name 'bug' -Tooltip 'start a bug report'
    New-Completion -Name 'build' -Tooltip 'compile packages and dependencies'
    New-Completion -Name 'clean' -Tooltip 'remove object files and cached files'
    New-Completion -Name 'doc' -Tooltip 'show documentation for package or symbol'
    New-Completion -Name 'env' -Tooltip 'print Go environment information'
    New-Completion -Name 'fix' -Tooltip 'update packages to use new APIs'
    New-Completion -Name 'fmt' -Tooltip 'gofmt (reformat) package sources'
    New-Completion -Name 'generate' -Tooltip 'generate Go files by processing source'
    New-Completion -Name 'get' -Tooltip 'add dependencies to current module and install them'
    New-Completion -Name 'install' -Tooltip 'compile and install packages and dependencies'
    New-Completion -Name 'list' -Tooltip 'list packages or modules'
    New-Completion -Name 'mod' -Tooltip 'module maintenance'
    New-Completion -Name 'work' -Tooltip 'workspace maintenance'
    New-Completion -Name 'run' -Tooltip 'compile and run Go program'
    New-Completion -Name 'test' -Tooltip 'test packages'
    New-Completion -Name 'tool' -Tooltip 'run specified go tool'
    New-Completion -Name 'version' -Tooltip 'print Go version'
    New-Completion -Name 'vet' -Tooltip 'report likely mistakes in packages'
)
