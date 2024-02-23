<#
.SYNOPSIS
    Notify the user when the internet connection is restored
.DESCRIPTION
    This script continuously checks for the internet connection
    and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1
    Continuously checks for the internet connection to "www.google.com"
    every 5 seconds and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1 -TargetName "www.example.com" -Interval 10
    Continuously checks for the internet connection to "www.example.com"
    every 10 seconds and notifies the user when the connection is restored
#>

param (
    # The target website to check for internet connection (default: "www.google.com")
    [string] $TargetName = "www.google.com",

    # The interval in seconds between each connection check (default: 5)
    [int]$Interval = 5
)

# Main loop to continuously check for the internet connection
while ($True) {
    # Check if the internet connection is restored
    $connection = Test-Connection -TargetName $TargetName -Count 1 -Quiet

    if ($connection.Status -eq 'Success') {
        # Internet connection is restored. Notify the user and exit the loop
        Write-Host "Internet Connection Restored" -ForegroundColor Green
        New-BurntToastNotification -Text "Internet Connection Restored" 
        break
    }

    # Wait for the specified interval before checking again
    Start-Sleep -Seconds $Interval
}
