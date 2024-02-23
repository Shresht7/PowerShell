<#
.SYNOPSIS
    Notify the user when the internet connection is restored
.DESCRIPTION
    This script continuously checks for the internet connection and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1
    Continuously checks for the internet connection and notifies the user when the connection is restored
#>

# Main loop to continuously check for the internet connection
while ($True) {
    # Check if the internet connection is restored
    $connection = Test-Connection -TargetName "www.google.com" -Count 1 -Quiet

    if ($connection.Status -eq 'Success') {
        # Internet connection is restored. Notify the user and exit the loop
        Write-Host "Internet Connection Restored" -ForegroundColor Green
        New-BurntToastNotification -Text "Internet Connection Restored" 
        break
    }

    # Wait for 5 seconds before checking again
    Start-Sleep -Seconds 5
}

