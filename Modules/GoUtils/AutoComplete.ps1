# Requires-Module AutoComplete

# --
# GO
# --

$GoCommands = @(
    [Completion]::new('help', 'get help', @())
    [Completion]::new('bug', 'start a bug report', @())
    [Completion]::new('build', 'compile packages and dependencies', @())
    [Completion]::new('clean', 'remove object files and cached files', @())
    [Completion]::new('doc', 'show documentation for package or symbol', @())
    [Completion]::new('env', 'print Go environment information', @())
    [Completion]::new('fix', 'update packages to use new APIs', @())
    [Completion]::new('fmt', 'gofmt (reformat) package sources', @())
    [Completion]::new('generate', 'generate Go files by processing source', @())
    [Completion]::new('get', 'add dependencies to current module and install them', @())
    [Completion]::new('install', 'compile and install packages and dependencies', @())
    [Completion]::new('list', 'list packages or modules', @())
    [Completion]::new('mod', 'module maintenance', @())
    [Completion]::new('work', 'workspace maintenance', @())
    [Completion]::new('run', 'compile and run Go program', @())
    [Completion]::new('test', 'test packages', @())
    [Completion]::new('tool', 'run specified go tool', @())
    [Completion]::new('version', 'print Go version', @())
    [Completion]::new('vet', 'report likely mistakes in packages', @())
)

Register-CommandCompleter -Name go -Tooltip 'Go CLI' -Completions $GoCommands
