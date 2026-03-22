$script:CodeOptions = @(
    @{ Name = "-" ; Tooltip = "Read from stdin" }    
    @{ Name = "--diff"; Short = "-d"; Tooltip = "Compare two files with each other." }
    @{ Name = "--merge" ; Short = "-m" ; Tooltip = "Perform a three-way merge by providing paths for two modified versions of a file, the common origin of both modified versions and the output file to save merge results." }
    @{ Name = "--add" ; Short = "-a" ; Tooltip = "Add folder(s) to the last active window." }
    @{ Name = "--remove" ; Short = "-r" ; Tooltip = "Remove folder(s) from the last active window." }
    @{ Name = "--goto" ; Short = "-g" ; Tooltip = "Open a file at the path on the specified line and character position." }
    @{ Name = "--new-window" ; Short = "-n" ; Tooltip = "Force to open a new window." }
    @{ Name = "--reuse-window" ; Short = "-r" ; Tooltip = "Force to open a file or folder in an already opened window." }
    @{ Name = "--sessions" ; Tooltip = "Opens the sessions window." }
    @{ Name = "--wait" ; Short = "-w" ; Tooltip = "Wait for the files to be closed before returning." }
    @{ Name = "--locale" ; Tooltip = "The locale to use (e.g. en-US or zh-TW)." }
    @{ Name = "--user-data-dir" ; Tooltip = "Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code." }
    @{ Name = "--profile" ; Tooltip = "Opens the provided folder or workspace with the given profile and associates the profile with the workspace. If the profile does not exist, a new empty one is created." }
    @{ Name = "--help" ; Short = "-h" ; Tooltip = "Print usage." }

    # Extensions
    @{ Name = "--extensions-dir" ; Tooltip = "Set the root path for extensions." }
    @{ Name = "--list-extensions" ; Tooltip = "List the installed extensions." }
    @{ Name = "--show-versions" ; Tooltip = "Show versions of installed extensions, when using --list-extensions." }
    @{ Name = "--category" ; Tooltip = "Filters installed extensions by provided category, when using --list-extensions." }
    @{ Name = "--install-extension" ; Tooltip = "Installs or updates an extension. The argument is either an extension id or a path to a VSIX. The identifier of an extension is '${publisher}.${name}'. Use '--force' argument to update to latest version. To install a specific version provide '@${version}'. For example: 'vscode.csharp@1.2.3'." }
    @{ Name = "--pre-release" ; Tooltip = "Installs the pre-release version of the extension, when using --install-extension." }
    @{ Name = "--uninstall-extension" ; Tooltip = "Uninstalls an extension." }
    @{ Name = "--update-extensions" ; Tooltip = "Update the installed extensions." }
    @{ Name = "--enable-proposed-api" ; Tooltip = "Enables proposed API features for extensions. Can receive one or more extension IDs to enable individually." }

    # Model Context Protocol
    @{ Name = "--add-mcp" ; Tooltip = "Adds a Model Context Protocol server definition to the user profile. Accepts JSON input in the form '{\`"name\`":\`"server-name\`",\`"command\`":...}'" }

    # Troubleshooting
    @{ Name = "--version" ; Short = "-v" ; Tooltip = "Print version." }
    @{ Name = "--verbose" ; Tooltip = "Print verbose output (implies --wait)." }
    @{ Name = "--log" ; Tooltip = "Log level to use. Default is 'info'. Allowed values are 'critical', 'error', 'warn', 'info', 'debug', 'trace', 'off'. You can also configure the log level of an extension by passing extension id and log level in the following format: '${publisher}.${name}:${logLevel}'. For example: 'vscode.csharp:trace'. Can receive one or more such entries." }
    @{ Name = "--status" ; Short = "-s" ; Tooltip = "Print process usage and diagnostics information." }
    @{ Name = "--prof-startup" ; Tooltip = "Run CPU profiler during startup." }
    @{ Name = "--disable-extensions" ; Tooltip = "Disable all installed extensions. This option is not persisted and is effective only when the command opens a new window." }
    @{ Name = "--disable-extension" ; Tooltip = "Disable the provided extension. This option is not persisted and is effective only when the command opens a new window." }
    @{ Name = "--sync" ; Tooltip = "Turn sync on or off." }
    @{ Name = "--inspect-extensions" ; Tooltip = "Allow debugging and profiling of extensions. Check the developer tools for the connection URI." }
    @{ Name = "--inspect-brk-extensions" ; Tooltip = "Allow debugging and profiling of extensions with the extension host being paused after start. Check the developer tools for the connection URI." }
    @{ Name = "--disable-lcd-text" ; Tooltip = "Disable LCD font rendering." }
    @{ Name = "--disable-gpu" ; Tooltip = "Disable GPU hardware acceleration." }
    @{ Name = "--disable-chromium-sandbox" ; Tooltip = "Use this option only when there is requirement to launch the application as sudo user on Linux or when running as an elevated user in an applocker environment on Windows." }
    @{ Name = "--locate-shell-integration-path" ; Tooltip = "Print the path to a terminal shell integration script. Allowed values are 'bash', 'pwsh', 'zsh' or 'fish'." }
    @{ Name = "--telemetry" ; Tooltip = "Shows all telemetry events which VS code collects." }
    @{ Name = "--transient" ; Tooltip = "Run with temporary data and extension directories, as if launched for the first time." }
)

$script:CodeSubCommands = @(
    @{ Name = "chat" ; Tooltip = "Pass in a prompt to run in a chat session in the current working directory." }
    @{ Name = "serve-web" ; Tooltip = "Run a server that displays the editor UI in browsers." }
    @{ Name = "tunnel" ; Tooltip = "Make the current machine accessible from vscode.dev or other machines through a secure tunnel." }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -CommandName code -Native -ScriptBlock {
    param ($wordToComplete, $commandAst, $cursorPosition)

    # Flags / Options
    $script:CodeOptions |
    ForEach-Object {
        if ($_.Name -like "$wordToComplete*") {
            [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterName', $_.Tooltip)
        }
    }

    # Subcommands (e.g. 'chat', 'serve-web', etc.)
    $script:CodeSubCommands |
    ForEach-Object {
        if ($_.Name -like "$wordToComplete*") {
            [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
        }
    }

}
