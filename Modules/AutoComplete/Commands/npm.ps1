# ===
# NPM
# ===

# -------
# HELPERS
# -------

# Retrieves package information from the package json
function Get-PackageJson(
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = $PWD.Path
) {
    $PackageJson = Join-Path $Path "package.json"
    return Get-Content $PackageJson -ErrorAction SilentlyContinue | ConvertFrom-Json
}

# Retrieves the list of npm scripts from the package json
function Get-NpmScript(
    [ValidateScript({ Test-Path $_ })]
    [string]$Path = $PWD.Path
) {
    $Package = Get-PackageJson $Path

    if (-Not $Package) { return }

    $Scripts = $Package.scripts
    | Get-Member -MemberType NoteProperty
    | Select-Object -Property Name, @{Name = "Script"; Expression = { $Package.scripts.($_.Name) } }

    return $Scripts
}

# ---------
# COMPLETER
# ---------

# TODO: Add the remaining commands as needed

$NPMCommands = @(
    [Completion]::new('access', 'Used to set access controls on private packages', @(
            [Completion]::new('list', '', @())
            [Completion]::new('get', '', @())
            [Completion]::new('set', '', @())
            [Completion]::new('grant', '', @())
            [Completion]::new('revoke', '', @())
        ))
    [Completion]::new('adduser')
    [Completion]::new('audit', 'Run a security audit', @(
            [Completion]::new('fix', 'Apply remediation to the package tree')
            [Completion]::new('signatures', 'Verify the signature of the downloaded packages')
        ))
    [Completion]::new('bugs')
    [Completion]::new('cache', 'Used to add, list or clean npm cache', @(
            [Completion]::new('add')
            [Completion]::new('clean')
            [Completion]::new('ls')
            [Completion]::new('verify')
        ))
    [Completion]::new('ci', 'Similar to npm install; meant to be used in automated environments')
    [Completion]::new('completion', 'Enables tab-completion in all npm commands')
    [Completion]::new('config', 'change the npm configs', @(
            [Completion]::new('set')
            [Completion]::new('get')
            [Completion]::new('delete')
            [Completion]::new('list')
            [Completion]::new('edit')
            [Completion]::new('fix')
        ))
    [Completion]::new('dedupe', 'Simplifies the overall structure by moving dependencies further up the tree')
    [Completion]::new('deprecate', 'Update the npm registry entry for a package, providing a deprecation warning to all who attempt to install it')
    [Completion]::new('diff', 'Prints the diff of patches of files for packages published to the npm registry')
    [Completion]::new('dist-tag', 'Add, remove and enumerate distribution tags', @(
            [Completion]::new('add')
            [Completion]::new('rm')
            [Completion]::new('ls')
        ))
    [Completion]::new('docs', "Guesses the package's likely location of a package's documentation URL")
    [Completion]::new('doctor', 'Runs a set of checks to ensure that your npm installation has what it needs')
    [Completion]::new('edit', 'Selects a dependency in the current project and opens the package folder in the default editor')
    [Completion]::new('exec', 'Runs arbitrary command form an npm package (either one installed locally or fetched remotely)')
    [Completion]::new('explain', 'Prints the chain of dependencies causing a given package to be installed in the current project')
    [Completion]::new('explore', 'Spawn a subshell in the directory of the installed package specified')
    [Completion]::new('find-dupes', 'Runs `npm dedupe` in `--dry-run` mode, making npm only output duplications without alteration')
    [Completion]::new('fund', 'Retrieves information on how to fund the dependencies of a given project')
    [Completion]::new('help', 'Show the appropriate documentation page')
    [Completion]::new('help-search', 'Search the npm markdown documentation files for the term provided, and then list the results, sorted by relevance')
    [Completion]::new('hook', 'Allows you to manage `npm hooks`, including adding, removing, listing and updating', @(
            [Completion]::new('add')
            [Completion]::new('ls')
            [Completion]::new('rm')
            [Completion]::new('update')
        ))
    [Completion]::new('init', 'Initialize an npm package')
    [Completion]::new('install', 'Install a package', @(
            [Completion]::new('-g', 'Global')
            [Completion]::new('--global', 'Global')
            [Completion]::new('--save-dev', 'Save as dev-dependency')
        ))
    [Completion]::new('link', 'This is handy for installing your own stuff, so that you can work on it and test iteratively without having to continually rebuild')
    [Completion]::new('login', 'Verify a user in the specified registry, and save the credentials to the `.npmrc` file. IF no registry is specified, the default registry will be used')
    [Completion]::new('logout', "When logged into a registry that supports token-based authentication, tell the server to end the token's session")
    [Completion]::new('ls', 'Prints to stdout all the versions of packages that are installed, as well as their dependencies when `--all` is specified, in a tree structure')
    [Completion]::new('outdated', 'Checks the registry to see if any (or specific) installed packages are currently outdated')
    [Completion]::new('owner', 'Manage ownership of published packages', @(
            [Completion]::new('add')
            [Completion]::new('rm')
            [Completion]::new('ls')
        ))
    [Completion]::new('ping', 'Ping the configured or given npm registry and verify authentication')
    [Completion]::new('pkg', 'Automates management of `package.json` files', @(
            [Completion]::new('set')
            [Completion]::new('get')
            [Completion]::new('delete')
        ))
    [Completion]::new('prefix', 'Print the local prefix to standard output', @(
            [Completion]::new('-g')
            [Completion]::new('--global')
        ))
    [Completion]::new('profile', 'Change your profile information on the registry', @(
            [Completion]::new('enable-2fa')
            [Completion]::new('disable-2fa')
            [Completion]::new('get')
            [Completion]::new('set')
        ))
    [Completion]::new('prune', 'Removes extraneous packages', @(
            [Completion]::new('--production')
            [Completion]::new('--no-production')
            [Completion]::new('--dry-run')
            [Completion]::new('--json')
        ))
    [Completion]::new('publish', 'Publishes a package to the registry so that it can be installed by name')
    [Completion]::new('query', 'Allows for usage of css selectors in order to retrieve an array of dependency objects')
    [Completion]::new('repo', "This command tries to guess at the likely location of a package's repository URL")
    [Completion]::new('restart', 'Restarts a project')
    [Completion]::new('root', 'Prints the effective `node_modules` folder to stdout')
    [Completion]::new('run', 'Run arbitrary script package', @(), {
            (Get-NpmScript | ForEach-Object { [Completion]::new($_.Name, $_.Script) })
        })
    [Completion]::new('search', 'Search for packages')
    [Completion]::new('star', '"Starring" a package means you have some interest in it')
    [Completion]::new('stars', 'If you have starred a lot of neat things and what to find them again quickly this command lets you do just that')
    [Completion]::new('start', 'Start a package')
    [Completion]::new('stop', 'Stop a package')
    [Completion]::new('test', 'Test a package')
    [Completion]::new('token', 'Manage your authentication tokens', @(
            [Completion]::new('list', 'Show a table of all active authentication tokens')
            [Completion]::new('revoke', 'Remove an authentication token')
            [Completion]::new('create', 'Create a new authentication token')
        ))
    [Completion]::new('uninstall', 'Remove a package')
    [Completion]::new('unstar', 'Removes an item from your favorite packages')
    [Completion]::new('update', 'Update packages', @(
            [Completion]::new('--global', 'Update global packages')
        ))
    [Completion]::new('version', 'Bump a package version', @(
            [Completion]::new('major')
            [Completion]::new('minor')
            [Completion]::new('patch')
            [Completion]::new('premajor')
            [Completion]::new('preminor')
            [Completion]::new('prepatch')
            [Completion]::new('prerelease')
            [Completion]::new('from-git')
        ))
    [Completion]::new('whoami', 'Display npm username', @(
            [Completion]::new('--registry', 'The base URL of the npm registry (Default: "https://registry.npmjs.org/")')
        ))
)

Register-CommandCompleter -Name npm -Tooltip 'Node Package Manager' -Completions $NPMCommands
