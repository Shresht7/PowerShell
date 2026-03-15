$script:CargoTopLevelCommands = @(
    @{ Name = "add" ; Tooltip = "Add dependencies to a Cargo.toml manifest file" }
    @{ Name = "b" ; Tooltip = "alias: build" }
    @{ Name = "bench" ; Tooltip = "Execute all benchmarks of a local package" }
    @{ Name = "build" ; Tooltip = "Compile a local package and all of its dependencies" }
    @{ Name = "c" ; Tooltip = "alias: check" }
    @{ Name = "check" ; Tooltip = "Check a local package and all of its dependencies for errors" }
    @{ Name = "clean" ; Tooltip = "Remove artifacts that cargo has generated in the past" }
    @{ Name = "clippy" ; Tooltip = "Checks a package to catch common mistakes and improve your Rust code." }
    @{ Name = "config" ; Tooltip = "Inspect configuration values" }
    @{ Name = "d" ; Tooltip = "alias: doc" }
    @{ Name = "doc" ; Tooltip = "Build a package's documentation" }
    @{ Name = "fetch" ; Tooltip = "Fetch dependencies of a package from the network" }
    @{ Name = "fix" ; Tooltip = "Automatically fix lint warnings reported by rustc" }
    @{ Name = "fmt" ; Tooltip = "Formats all bin and lib files of the current crate using rustfmt." }
    @{ Name = "generate-lockfile" ; Tooltip = "Generate the lockfile for a package" }
    @{ Name = "git-checkout" ; Tooltip = "REMOVED: This command has been removed" }
    @{ Name = "help" ; Tooltip = "Displays help for a cargo command" }
    @{ Name = "info" ; Tooltip = "Display information about a package" }
    @{ Name = "init" ; Tooltip = "Create a new cargo package in an existing directory" }
    @{ Name = "install" ; Tooltip = "Install a Rust binary" }
    @{ Name = "locate-project" ; Tooltip = "Print a JSON representation of a Cargo.toml file's location" }
    @{ Name = "login" ; Tooltip = "Log in to a registry." }
    @{ Name = "logout" ; Tooltip = "Remove an API token from the registry locally" }
    @{ Name = "metadata" ; Tooltip = "Output the resolved dependencies of a package, the concrete used versions including overrides, in machine-readable format" }
    @{ Name = "miri" ; Tooltip = "" }
    @{ Name = "new" ; Tooltip = "Create a new cargo package at <path>" }
    @{ Name = "owner" ; Tooltip = "Manage the owners of a crate on the registry" }
    @{ Name = "package" ; Tooltip = "Assemble the local package into a distributable tarball" }
    @{ Name = "pkgid" ; Tooltip = "Print a fully qualified package specification" }
    @{ Name = "publish" ; Tooltip = "Upload a package to the registry" }
    @{ Name = "r" ; Tooltip = "alias: run" }
    @{ Name = "read-manifest" ; Tooltip = "DEPRECATED: Print a JSON representation of a Cargo.toml manifest." }
    @{ Name = "remove" ; Tooltip = "Remove dependencies from a Cargo.toml manifest file" }
    @{ Name = "report" ; Tooltip = "Generate and display various kinds of reports" }
    @{ Name = "rm" ; Tooltip = "alias: remove" }
    @{ Name = "run" ; Tooltip = "Run a binary or example of the local package" }
    @{ Name = "rustc" ; Tooltip = "Compile a package, and pass extra options to the compiler" }
    @{ Name = "rustdoc" ; Tooltip = "Build a package's documentation, using specified custom flags." }
    @{ Name = "search" ; Tooltip = "Search packages in the registry. Default registry is crates.io" }
    @{ Name = "t" ; Tooltip = "alias: test" }
    @{ Name = "test" ; Tooltip = "Execute all unit and integration tests and build examples of a local package" }
    @{ Name = "tree" ; Tooltip = "Display a tree visualization of a dependency graph" }
    @{ Name = "uninstall" ; Tooltip = "Remove a Rust binary" }
    @{ Name = "update" ; Tooltip = "Update dependencies as recorded in the local lock file" }
    @{ Name = "vendor" ; Tooltip = "Vendor all dependencies for a project locally" }
    @{ Name = "verify-project" ; Tooltip = "DEPRECATED: Check correctness of crate manifest." }
    @{ Name = "version" ; Tooltip = "Show version information" }
    @{ Name = "yank" ; Tooltip = "Remove a pushed crate from the index" }
)

$script:CargoOptions = @(
    @{ Name = "--version" ; Short = "-V" ; Tooltip = "Print version info and exit" }
    @{ Name = "--list" ; Tooltip = "List installed commands" }
    @{ Name = "--explain" ; Tooltip = "Provide a detailed explanation of a rustc error message" }
    @{ Name = "--verbose..." ; Short = "-v" ; Tooltip = "Use verbose output (-vv very verbose/build.rs output)" }
    @{ Name = "--quiet" ; Short = "-q" ; Tooltip = "Do not print cargo log messages" }
    @{ Name = "--color" ; Tooltip = "Coloring [possible values: auto, always, never]" }
    @{ Name = "-C" ; Tooltip = "Change to DIRECTORY before doing anything (nightly-only)" }
    @{ Name = "--locked" ; Tooltip = "Assert that `Cargo.lock` will remain unchanged" }
    @{ Name = "--offline" ; Tooltip = "Run without accessing the network" }
    @{ Name = "--frozen" ; Tooltip = "Equivalent to specifying both --locked and --offline" }
    @{ Name = "--config" ; Tooltip = "Override a configuration value" }
    @{ Name = "-Z" ; Tooltip = "Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details" }
    @{ Name = "--help" ; Short = "-h" ; Tooltip = "Print help" }
)

$script:CargoColorValues = @(
    @{ Name = "auto"; Tooltip = "Use colors if the output is a terminal" }
    @{ Name = "always"; Tooltip = "Always use colors" }
    @{ Name = "never"; Tooltip = "Never use colors" }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName cargo -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # Get the command elements as text (e.g. 'cargo', 'build', etc.)
    $elements = @($commandAst.CommandElements | ForEach-Object { $_.Extent.Text })

    # Get the previous element (e.g. 'build' if the user has typed 'cargo build ')
    $previous = if ($elements.Count -ge 2) { $elements[-1] } else { $null }

    # --color
    if ($previous -eq '--color') {
        $script:CargoColorValues |
        ForEach-Object {
            if ($_.Name -like "$wordToComplete*") {
                [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
            }
        }
        return
    }

    # Options
    if ($wordToComplete -like "-*") {
        $script:CargoOptions |
        Where-Object { $_.Name -like "$wordToComplete*" -or $_.Short -like "$wordToComplete*" } |
        ForEach-Object {
            if ($_.Short -like "$wordToComplete*") {
                [CompletionResult]::new($_.Short, $_.Short, 'ParameterValue', $_.Tooltip)
            }
            if ($_.Name -like "$wordToComplete*") {
                [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
            }
        }
        return
    }

    # Top level commands
    $script:CargoTopLevelCommands |
    Where-Object { $_.Name -like "$wordToComplete*" } |
    ForEach-Object {
        [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
    }
}
