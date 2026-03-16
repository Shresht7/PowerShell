$script:ScoopCommands = @(
    @{ Name = 'alias' ; Tooltip = "Manage scoop aliases" }
    @{ Name = 'bucket' ; Tooltip = "Manage Scoop buckets" }
    @{ Name = 'cache' ; Tooltip = "Show or clear the download cache" }
    @{ Name = 'cat' ; Tooltip = "Show content of specified manifest." }
    @{ Name = 'checkup' ; Tooltip = "Check for potential problems" }
    @{ Name = 'cleanup' ; Tooltip = "Cleanup apps by removing old versions" }
    @{ Name = 'config' ; Tooltip = "Get or set configuration values" }
    @{ Name = 'create' ; Tooltip = "Create a custom app manifest" }
    @{ Name = 'depends' ; Tooltip = "List dependencies for an app, in the order they'll be installed" }
    @{ Name = 'download' ; Tooltip = "Download apps in the cache folder and verify hashes" }
    @{ Name = 'export' ; Tooltip = "Exports installed apps, buckets (and optionally configs) in JSON format" }
    @{ Name = 'help' ; Tooltip = "Show help for a command" }
    @{ Name = 'hold' ; Tooltip = "Hold an app to disable updates" }
    @{ Name = 'home' ; Tooltip = "Opens the app homepage" }
    @{ Name = 'import' ; Tooltip = "Imports apps, buckets and configs from a Scoopfile in JSON format" }
    @{ Name = 'info' ; Tooltip = "Display information about an app" }
    @{ Name = 'install' ; Tooltip = "Install apps" }
    @{ Name = 'list' ; Tooltip = "List installed apps" }
    @{ Name = 'prefix' ; Tooltip = "Returns the path to the specified app" }
    @{ Name = 'reset' ; Tooltip = "Reset an app to resolve conflicts" }
    @{ Name = 'search' ; Tooltip = "Search available apps" }
    @{ Name = 'shim' ; Tooltip = "Manipulate Scoop shims" }
    @{ Name = 'status' ; Tooltip = "Show status and check for new app versions" }
    @{ Name = 'unhold' ; Tooltip = "Unhold an app to enable updates" }
    @{ Name = 'uninstall' ; Tooltip = "Uninstall an app" }
    @{ Name = 'update' ; Tooltip = "Update apps, or Scoop itself" }
    @{ Name = 'virustotal' ; Tooltip = "Look for app's hash or url on virustotal.com" }
    @{ Name = 'which' ; Tooltip = "Locate a shim/executable (similar to 'which' on Linux)" }
)

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName scoop -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # Top level commands
    $script:ScoopCommands
    | Where-Object { $_.Name -like "$wordToComplete*" }
    | ForEach-Object {
        [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip)
    }
}
