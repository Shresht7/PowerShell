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

$script:FdTypeValues = @(
    @{ Name = "file"; Short = "f"; Tooltip = "Search for files" }
    @{ Name = "directory"; Short = "d"; Tooltip = "Search for directories" }
    @{ Name = "symlink"; Short = "l"; Tooltip = "Search for symbolic links" }
    @{ Name = "executable"; Short = "x"; Tooltip = "Search for executable files" }
    @{ Name = "empty"; Short = "e"; Tooltip = "Search for empty files and directories" }
    @{ Name = "socket"; Short = "s"; Tooltip = "Search for sockets" }
    @{ Name = "pipe"; Short = "p"; Tooltip = "Search for named pipes (FIFOs)" }
    @{ Name = "char-device"; Short = "c"; Tooltip = "Search for character devices" }
    @{ Name = "block-device"; Short = "b"; Tooltip = "Search for block devices" }
)

$script:FdColorValues = @(
    @{ Name = "auto"; Tooltip = "Use colors if the output is a terminal" }
    @{ Name = "always"; Tooltip = "Always use colors" }
    @{ Name = "never"; Tooltip = "Never use colors" }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName fd -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # Get the command elements as text (e.g. 'fd', '--type', 'file', etc.)
    $elements = @($commandAst.CommandElements | ForEach-Object { $_.Extent.Text })

    # Get the previous element (e.g. '--type' if the user has typed 'fd --type ')
    $previous = if ($elements.Count -ge 2) { $elements[-1] } else { $null }

    # --type
    if ($previous -eq '--type' -or $previous -eq '-t') {
        $script:FdTypeValues |
        ForEach-Object {
            if ($_.Short -like "$wordToComplete*") {
                [CompletionResult]::new($_.Short, $_.Short, 'ParameterValue', $_.Tooltip)
            }
            elseif ($_.Name -like "$wordToComplete*") {
                [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
            }
        }
        return
    }

    # --color
    if ($previous -eq '--color' -or $previous -eq '-c') {
        $script:FdColorValues |
        ForEach-Object {
            if ($_.Short -like "$wordToComplete*") {
                [CompletionResult]::new($_.Short, $_.Short, 'ParameterValue', $_.Tooltip)
            }
            elseif ($_.Name -like "$wordToComplete*") {
                [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
            }
        }
        return
    }

    # Options
    $script:FdOptions |
    ForEach-Object {
        if ($_.Short -like "$wordToComplete*") {
            [CompletionResult]::new($_.Short, $_.Short, 'ParameterValue', $_.Tooltip)
        }
        elseif ($_.Name -like "$wordToComplete*") {
            [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
        }
    }
}
