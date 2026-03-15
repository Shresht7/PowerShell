$script:FdOptions = @(
    @{ Name = "--hidden"; Short = "-H"; Tooltip = "Search hidden files and directories" }
    @{ Name = "--no-ignore"; Short = "-I"; Tooltip = "Do not respect .(git | fd)ignore files" }
    @{ Name = "--case-sensitive"; Short = "-s"; Tooltip = "Case-sensitive search (default: smart case)" }
    @{ Name = "--ignore-case"; Short = "-i"; Tooltip = "Case-insensitive search (default: smart case)" }
    @{ Name = "--glob"; Short = "-g"; Tooltip = "Glob-based search (default: regular expression)" }
    @{ Name = "--absolute-path"; Short = "-a"; Tooltip = "Show absolute instead of relative paths" }
    @{ Name = "--list-details"; Short = "-l"; Tooltip = "Use a long listing format with file metadata" }
    @{ Name = "--follow"; Short = "-L"; Tooltip = "Follow symbolic links" }
    @{ Name = "--full-path"; Short = "-p"; Tooltip = "Search full abs. path (default: filename only)" }
    @{ Name = "--max-depth"; Short = "-d"; Tooltip = "Set maximum search depth (default: none)" }
    @{ Name = "--exclude"; Short = "-E"; Tooltip = "Exclude entries that match the given glob pattern" }
    @{ Name = "--type"; Short = "-t"; Tooltip = "Filter by type: file (f), directory (d/dir), symlink (l), executable (x), empty (e), socket (s), pipe (p), char-device (c), block-device (b)" }
    @{ Name = "--extension"; Short = "-e"; Tooltip = "Filter by file extension" }
    @{ Name = "--size"; Short = "-S"; Tooltip = "Limit results based on the size of files" }
    @{ Name = "--changed-within"; Tooltip = "Filter by file modification time (newer than)" }
    @{ Name = "--changed-before"; Tooltip = "Filter by file modification time (older than)" }
    @{ Name = "--format"; Tooltip = "Print results according to template" }
    @{ Name = "--exec"; Short = "-x"; Tooltip = "Execute a command for each search result" }
    @{ Name = "--exec-batch"; Short = "-X"; Tooltip = "Execute a command with all search results at once" }
    @{ Name = "--color"; Short = "-c"; Tooltip = "When to use colors [default: auto] [possible values: auto, always, never]" }
    @{ Name = "--hyperlink"; Tooltip = "Add hyperlinks to output paths [default: never] [possible values: auto, always, never]" }
    @{ Name = "--ignore-contain"; Tooltip = "Ignore directories containing the named entry" }
    @{ Name = "--help"; Short = "-h"; Tooltip = "Print help (see more with '--help')" }
    @{ Name = "--version"; Short = "-V"; Tooltip = "Print version" }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName fd -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $script:FdOptions |
    Where-Object { $_.Name -like "$wordToComplete*" -or $_.Short -like "$wordToComplete*" } |
    ForEach-Object {
        [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
    }
}
