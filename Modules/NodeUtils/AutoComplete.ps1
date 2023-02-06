# Requires-Module AutoComplete

# ===
# NPM
# ===

# TODO: Add the remaining commands as needed

$NPMCommands = @(
    New-Completion -Name 'access' -Tooltip 'Used to set access controls on private packages' -Completions @(
        New-Completion -Name 'list'
        New-Completion -Name 'get'
        New-Completion -Name 'set'
        New-Completion -Name 'grant'
        New-Completion -Name 'revoke'
    )
    
    New-Completion -Name 'adduser'
    
    New-Completion -Name 'audit' -Tooltip 'Run a security audit' -Completions @(
        New-Completion -Name 'fix' -Tooltip 'Apply remediation to the package tree'
        New-Completion -Name 'signatures' -Tooltip 'Verify the signature of the downloaded packages'
    )
    
    New-Completion -Name 'bugs'
    
    New-Completion -Name 'cache' -Tooltip 'Used to add, list or clean npm cache' -Completions @(
        New-Completion -Name 'add'
        New-Completion -Name 'clean'
        New-Completion -Name 'ls'
        New-Completion -Name 'verify'
    )
    
    New-Completion -Name 'ci' -Tooltip 'Similar to npm install; meant to be used in automated environments'
    
    New-Completion -Name 'completion' -Tooltip 'Enables tab-completion in all npm commands'
    
    New-Completion -Name 'config' -Tooltip 'change the npm configs' -Completions @(
        New-Completion -Name 'set'
        New-Completion -Name 'get'
        New-Completion -Name 'delete'
        New-Completion -Name 'list'
        New-Completion -Name 'edit'
        New-Completion -Name 'fix'
    )

    New-Completion -Name 'dedupe' -Tooltip 'Simplifies the overall structure by moving dependencies further up the tree'

    New-Completion -Name 'deprecate' -Tooltip 'Update the npm registry entry for a package, providing a deprecation warning to all who attempt to install it'

    New-Completion -Name 'diff' -Tooltip 'Prints the diff of patches of files for packages published to the npm registry'

    New-Completion -Name 'dist-tag' -Tooltip 'Add, remove and enumerate distribution tags' -Completions @(
        New-Completion -Name 'add'
        New-Completion -Name 'rm'
        New-Completion -Name 'ls'
    )

    New-Completion -Name 'docs' -Tooltip "Guesses the package's likely location of a package's documentation URL"

    New-Completion -Name 'doctor' -Tooltip 'Runs a set of checks to ensure that your npm installation has what it needs'

    New-Completion -Name 'edit' -Tooltip 'Selects a dependency in the current project and opens the package folder in the default editor'

    New-Completion -Name 'exec' -Tooltip 'Runs arbitrary command form an npm package (either one installed locally or fetched remotely)'

    New-Completion -Name 'explain' -Tooltip 'Prints the chain of dependencies causing a given package to be installed in the current project'

    New-Completion -Name 'explore' -Tooltip 'Spawn a subshell in the directory of the installed package specified'

    New-Completion -Name 'find-dupes' -Tooltip 'Runs `npm dedupe` in `--dry-run` mode, making npm only output duplications without alteration'

    New-Completion -Name 'fund' -Tooltip 'Retrieves information on how to fund the dependencies of a given project'

    New-Completion -Name 'help' -Tooltip 'Show the appropriate documentation page'

    New-Completion -Name 'help-search' -Tooltip 'Search the npm markdown documentation files for the term provided, and then list the results, sorted by relevance'

    New-Completion -Name 'hook' -Tooltip 'Allows you to manage `npm hooks`, including adding, removing, listing and updating' -Completions @(
        New-Completion -Name 'add'
        New-Completion -Name 'ls'
        New-Completion -Name 'rm'
        New-Completion -Name 'update'
    )

    New-Completion -Name 'init' -Tooltip 'Initialize an npm package'

    New-Completion -Name 'install' -Tooltip 'Install a package' -Completions @(
        New-Completion -Name '-g' -Tooltip 'Global'
        New-Completion -Name '--global' -Tooltip 'Global'
        New-Completion -Name '--save-dev' -Tooltip 'Save as dev-dependency'
    )

    New-Completion -Name 'link' -Tooltip 'This is handy for installing your own stuff, so that you can work on it and test iteratively without having to continually rebuild'

    New-Completion -Name 'login' -Tooltip 'Verify a user in the specified registry, and save the credentials to the `.npmrc` file. IF no registry is specified, the default registry will be used'

    New-Completion -Name 'logout' -Tooltip "When logged into a registry that supports token-based authentication, tell the server to end the token's session"

    New-Completion -Name 'ls' -Tooltip 'Prints to stdout all the versions of packages that are installed, as well as their dependencies when `--all` is specified, in a tree structure'

    New-Completion -Name 'outdated' -Tooltip 'Checks the registry to see if any (or specific) installed packages are currently outdated'

    New-Completion -Name 'owner' -Tooltip 'Manage ownership of published packages' -Completions @(
        New-Completion -Name 'add'
        New-Completion -Name 'rm'
        New-Completion -Name 'ls'
    )

    New-Completion -Name 'ping' -Tooltip 'Ping the configured or given npm registry and verify authentication'

    New-Completion -Name 'pkg' -Tooltip 'Automates management of `package.json` files' -Completions @(
        New-Completion -Name 'set'
        New-Completion -Name 'get'
        New-Completion -Name 'delete'
    )

    New-Completion -Name 'prefix' -Tooltip 'Print the local prefix to standard output' -Completions @(
        New-Completion -Name '-g'
        New-Completion -Name '--global'
    )

    New-Completion -Name 'profile' -Tooltip 'Change your profile information on the registry' -Completions @(
        New-Completion -Name 'enable-2fa'
        New-Completion -Name 'disable-2fa'
        New-Completion -Name 'get'
        New-Completion -Name 'set'
    )

    New-Completion -Name 'prune' -Tooltip 'Removes extraneous packages' -Completions @(
        New-Completion -Name '--production'
        New-Completion -Name '--no-production'
        New-Completion -Name '--dry-run'
        New-Completion -Name '--json'
    )

    New-Completion -Name 'publish' -Tooltip 'Publishes a package to the registry so that it can be installed by name'

    New-Completion -Name 'query' -Tooltip 'Allows for usage of css selectors in order to retrieve an array of dependency objects'

    New-Completion -Name 'repo' -Tooltip "This command tries to guess at the likely location of a package's repository URL"

    New-Completion -Name 'restart' -Tooltip 'Restarts a project'

    New-Completion -Name 'root' -Tooltip 'Prints the effective `node_modules` folder to stdout'

    New-Completion -Name 'run' -Tooltip 'Run arbitrary script package' -Completions @() -Script {
            (Get-NpmScript | ForEach-Object { New-Completion -Name $_.Name -Tooltip $_.Script })
    }

    New-Completion -Name 'search' -Tooltip 'Search for packages'

    New-Completion -Name 'star' -Tooltip '"Starring" a package means you have some interest in it'

    New-Completion -Name 'stars' -Tooltip 'If you have starred a lot of neat things and what to find them again quickly this command lets you do just that'

    New-Completion -Name 'start' -Tooltip 'Start a package'

    New-Completion -Name 'stop' -Tooltip 'Stop a package'

    New-Completion -Name 'test' -Tooltip 'Test a package'

    New-Completion -Name 'token' -Tooltip 'Manage your authentication tokens' -Completions @(
        New-Completion -Name 'list' -Tooltip 'Show a table of all active authentication tokens'
        New-Completion -Name 'revoke' -Tooltip 'Remove an authentication token'
        New-Completion -Name 'create' -Tooltip 'Create a new authentication token'
    )

    New-Completion -Name 'uninstall' -Tooltip 'Remove a package'

    New-Completion -Name 'unstar' -Tooltip 'Removes an item from your favorite packages'

    New-Completion -Name 'update' -Tooltip 'Update packages' -Completions @(
        New-Completion -Name '--global' -Tooltip 'Update global packages'
    )

    New-Completion -Name 'version' -Tooltip 'Bump a package version' -Completions @(
        New-Completion -Name 'major'
        New-Completion -Name 'minor'
        New-Completion -Name 'patch'
        New-Completion -Name 'premajor'
        New-Completion -Name 'preminor'
        New-Completion -Name 'prepatch'
        New-Completion -Name 'prerelease'
        New-Completion -Name 'from-git'
    )

    New-Completion -Name 'whoami' -Tooltip 'Display npm username' -Completions @(
        New-Completion -Name '--registry' -Tooltip 'The base URL of the npm registry (Default: "https://registry.npmjs.org/")'
    )
)

Register-CommandCompleter -Name npm -Tooltip 'Node Package Manager' -Completions $NPMCommands
