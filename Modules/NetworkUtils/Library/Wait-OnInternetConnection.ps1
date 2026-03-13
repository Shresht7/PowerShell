<#
.SYNOPSIS
    Waits for the internet connection to be restored and executes a script block when it is
.DESCRIPTION
    This function continuously checks for the internet connection to a specified target (default: "www.google.com")
    and executes a provided script block when the connection is restored.
    Returns $true if the connection is restored, or $false if the function is interrupted or encounters an error.
.EXAMPLE
    Wait-OnInternetConnection -Target "www.example.com" -OnConnectionRestored { Write-Host "Connection to www.example.com is back!" }
    Continuously checks for the internet connection to "www.example.com" every 30 seconds and writes a message to the console when the connection is restored.
.EXAMPLE
    Wait-OnInternetConnection -OnConnectionRestored { git push }
    Continuously checks for the internet connection to "www.google.com" every 30 seconds and executes a git push when the connection is restored.
.EXAMPLE
    if (Wait-OnInternetConnection -Target "www.google.com") {
        Start-Process "https://www.google.com/search?q=GitHub"
    }
    Continuously checks for the internet connection to "www.google.com" every 30 seconds and opens a browser to search for "GitHub" when the connection is restored.
.NOTES
    This function is designed to be flexible and can be used in various scenarios where you want to wait for the internet connection to be restored before performing an action.
    The script block provided to the -OnConnectionRestored parameter will be executed in the context of the function, so it can access any variables or functions defined within that context.
    The function will continue to check for the internet connection until it is restored, and it will return $true if the connection is successfully restored. If the function is interrupted (e.g., by pressing Ctrl+C) or encounters an error, it will return $false.
#>
function Wait-OnInternetConnection {
    [CmdletBinding()]
    param (
        # The target website to check for internet connection (default: "www.google.com")
        [string]$Target = "www.google.com",

        # The script block to execute when the connection is restored
        [Alias("OnSuccess", "OnResume", "Script", "ScriptBlock")]
        [ScriptBlock] $OnConnectionRestored,

        # The interval in seconds between each connection check (default: 30)
        [int]$Interval = 30
    )

    Write-Host "Checking for Internet connectivity..."

    $Result = $false

    # Main loop to continuously check for the internet connection
    while ($True) {
        # Check if the internet connection is restored
        $Connection = Test-Connection -Target $Target -Count 1 -Quiet

        # If the connection is restored, notify the user and exit the loop
        if ($Connection -eq $true) {
            Write-Host "Internet Connection Restored" -ForegroundColor Green

            # If a script block is provided, execute it
            if ($OnConnectionRestored) {
                Invoke-Command -ScriptBlock $OnConnectionRestored
            }

            # Set the result to true and break the loop
            $Result = $Connection
            break
        }

        # Wait for the specified interval before checking again
        Start-Sleep -Seconds $Interval
    }

    # Return the result of the connection test (true if restored, false otherwise)
    return $Result
}
