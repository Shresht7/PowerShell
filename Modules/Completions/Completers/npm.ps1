$script:NodeTopLevelCommands = @(
    @{ Name = 'access'; Tooltip = "Used to set access controls on private packages" ; Completions = @(
            @{ Name = 'list' }
            @{ Name = 'get' }
            @{ Name = 'set' }
            @{ Name = 'grant' }
            @{ Name = 'revoke' }
        )
    }

    @{ Name = 'adduser' }

    @{ Name = 'audit'; Tooltip = "Run a security audit" ; Completions = @(
            @{ Name = 'fix'; Tooltip = "Apply remediation to the package tree" }
            @{ Name = 'signatures'; Tooltip = "Verify the signature of the downloaded packages" }
        )
    }

    @{ Name = 'bugs' }

    @{ Name = 'cache'; Tooltip = "Used to add, list or clean npm cache" ; Completions = @(
            @{ Name = 'add' }
            @{ Name = 'clean' }
            @{ Name = 'ls' }
            @{ Name = 'verify' }
        )
    }

    @{ Name = 'ci'; Tooltip = "Similar to npm install; meant to be used in automated environments" }

    @{ Name = 'completion'; Tooltip = "Enables tab-completion in all npm commands" }

    @{ Name = 'config'; Tooltip = "change the npm configs" ; Completions = @(
            @{ Name = 'set' }
            @{ Name = 'get' }
            @{ Name = 'delete' }
            @{ Name = 'list' }
            @{ Name = 'edit' }
            @{ Name = 'fix' }
        )
    }

    @{ Name = 'dedupe'; Tooltip = "Simplifies the overall structure by moving dependencies further up the tree" }

    @{ Name = 'deprecate'; Tooltip = "Update the npm registry entry for a package, providing a deprecation warning to all who attempt to install it" }

    @{ Name = 'diff'; Tooltip = "Prints the diff of patches of files for packages published to the npm registry" }

    @{ Name = 'dist-tag'; Tooltip = "Add, remove and enumerate distribution tags" ; Completions = @(
            @{ Name = 'add' }
            @{ Name = 'rm' }
            @{ Name = 'ls' }
        )
    }

    @{ Name = 'docs'; Tooltip = "Guesses the package's likely location of a package's documentation URL" }

    @{ Name = 'doctor'; Tooltip = "Runs a set of checks to ensure that your npm installation has what it needs" }

    @{ Name = 'edit'; Tooltip = "Selects a dependency in the current project and opens the package folder in the default editor" }

    @{ Name = 'exec' ; Tooltip = 'Runs arbitrary command form an npm package (either one installed locally or fetched remotely)' }

    @{ Name = 'explain' ; Tooltip = 'Prints the chain of dependencies causing a given package to be installed in the current project' }

    @{ Name = 'explore' ; Tooltip = 'Spawn a subshell in the directory of the installed package specified' }

    @{ Name = 'find-dupes' ; Tooltip = 'Runs `npm dedupe` in `--dry-run` mode, making npm only output duplications without alteration' }

    @{ Name = 'fund' ; Tooltip = 'Retrieves information on how to fund the dependencies of a given project' }

    @{ Name = 'help' ; Tooltip = 'Show the appropriate documentation page' }

    @{ Name = 'help-search' ; Tooltip = 'Search the npm markdown documentation files for the term provided, and then list the results, sorted by relevance' }

    @{ Name = 'hook' ; Tooltip = 'Allows you to manage `npm hooks`, including adding, removing, listing and updating' ; Completions = @(
            @{ Name = 'add' }
            @{ Name = 'ls' }
            @{ Name = 'rm' }
            @{ Name = 'update' }
        )
    }
    
    @{ Name = 'init' ; Tooltip = 'Initialize an npm package' }

    @{ Name = 'install' ; Tooltip = 'Install a package' ; Completions = @(
            @{ Name = '-g' ; Tooltip = 'Global' }
            @{ Name = '--global' ; Tooltip = 'Global' }
            @{ Name = '--save-dev' ; Tooltip = 'Save as dev-dependency' }
        )
    }
    
    @{ Name = 'link' ; Tooltip = 'This is handy for installing your own stuff, so that you can work on it and test iteratively without having to continually rebuild' }

    @{ Name = 'login' ; Tooltip = 'Verify a user in the specified registry, and save the credentials to the `.npmrc` file. IF no registry is specified, the default registry will be used' }

    @{ Name = 'logout' ; Tooltip = "When logged into a registry that supports token-based authentication, tell the server to end the token's session" }

    @{ Name = 'ls' ; Tooltip = 'Prints to stdout all the versions of packages that are installed, as well as their dependencies when `--all` is specified, in a tree structure' }

    @{ Name = 'outdated' ; Tooltip = 'Checks the registry to see if any (or specific) installed packages are currently outdated' }

    @{ Name = 'owner' ; Tooltip = 'Manage ownership of published packages' ; Completions = @(
            @{ Name = 'add' }
            @{ Name = 'rm' }
            @{ Name = 'ls' }
        )
    }
            
    @{ Name = 'ping' ; Tooltip = 'Ping the configured or given npm registry and verify authentication' }

    @{ Name = 'pkg' ; Tooltip = 'Automates management of `package.json` files' ; Completions = @(
            @{ Name = 'set' }
            @{ Name = 'get' }
            @{ Name = 'delete' }
        )
    }

    @{ Name = 'prefix' ; Tooltip = 'Print the local prefix to standard output' ; Completions = @(
            @{ Name = '-g' }
            @{ Name = '--global' }
        )
    }
            
    @{ Name = 'profile' ; Tooltip = 'Change your profile information on the registry' ; Completions = @(
            @{ Name = 'enable-2fa' }
            @{ Name = 'disable-2fa' }
            @{ Name = 'get' }
            @{ Name = 'set' }
        )
    }
            
    @{ Name = 'prune' ; Tooltip = 'Removes extraneous packages' ; Completions = @(
            @{ Name = '--production' }
            @{ Name = '--no-production' }
            @{ Name = '--dry-run' }
            @{ Name = '--json' }
        )
    }
            
    @{ Name = 'publish' ; Tooltip = 'Publishes a package to the registry so that it can be installed by name' }

    @{ Name = 'query' ; Tooltip = 'Allows for usage of css selectors in order to retrieve an array of dependency objects' }

    @{ Name = 'repo' ; Tooltip = "This command tries to guess at the likely location of a package's repository URL" }

    @{ Name = 'restart' ; Tooltip = 'Restarts a project' }

    @{ Name = 'root' ; Tooltip = 'Prints the effective `node_modules` folder to stdout' }

    @{ Name = 'run' ; Tooltip = 'Run arbitrary script package' ; Script = {
            $PackageJson = Get-Content "package.json" -ErrorAction SilentlyContinue | ConvertFrom-Json
            if ($PackageJson -and $PackageJson.scripts) {
                $PackageJson.scripts
                | Get-Member -MemberType NoteProperty
                | ForEach-Object { [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $PackageJson.scripts.$($_.Name)) }
            }
        }
    }

    @{ Name = 'search' ; Tooltip = 'Search for packages' }

    @{ Name = 'star' ; Tooltip = '"Starring" a package means you have some interest in it' }

    @{ Name = 'stars' ; Tooltip = 'If you have starred a lot of neat things and what to find them again quickly this command lets you do just that' }

    @{ Name = 'start' ; Tooltip = 'Start a package' }

    @{ Name = 'stop' ; Tooltip = 'Stop a package' }

    @{ Name = 'test' ; Tooltip = 'Test a package' }

    @{ Name = 'token' ; Tooltip = 'Manage your authentication tokens' ; Completions = @(
            @{ Name = 'list' ; Tooltip = 'Show a table of all active authentication tokens' }
            @{ Name = 'revoke' ; Tooltip = 'Remove an authentication token' }
            @{ Name = 'create' ; Tooltip = 'Create a new authentication token' }
        )
    }
        
    @{ Name = 'uninstall' ; Tooltip = 'Remove a package' }

    @{ Name = 'unstar' ; Tooltip = 'Removes an item from your favorite packages' }

    @{ Name = 'update' ; Tooltip = 'Update packages' ; Completions = @(
            @{ Name = '--global' ; Tooltip = 'Update global packages' }
        )
    }
        
    @{ Name = 'version' ; Tooltip = 'Bump a package version' ; Completions = @(
            @{ Name = 'major' }
            @{ Name = 'minor' }
            @{ Name = 'patch' }
            @{ Name = 'premajor' }
            @{ Name = 'preminor' }
            @{ Name = 'prepatch' }
            @{ Name = 'prerelease' }
            @{ Name = 'from-git' }
        )
    }

    @{ Name = 'whoami' ; Tooltip = 'Display npm username' ; Completions = @(
            @{ Name = '--registry' ; Tooltip = 'The base URL of the npm registry (Default: "https://registry.npmjs.org/")' }
        )
    }
) 

# ===========================
# REGISTER ARGUMENT COMPLETER
# ===========================

Register-ArgumentCompleter -Native -CommandName npm -ScriptBlock {
    param ($wordToComplete, $commandAst, $cursorPosition)

    # Top level commands
    $script:NodeTopLevelCommands
    | Where-Object { $_.Name -like "$wordToComplete*" }
    | ForEach-Object { [CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Tooltip) }
}

