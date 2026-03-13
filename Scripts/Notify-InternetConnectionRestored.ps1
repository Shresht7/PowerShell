<#
.SYNOPSIS
    Notify the user when the internet connection is restored
.DESCRIPTION
    This script continuously checks for the internet connection
    and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1
    Continuously checks for the internet connection to "www.google.com"
    every 30 seconds and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1 -TargetName "www.example.com" -Interval 10
    Continuously checks for the internet connection to "www.example.com"
    every 10 seconds and notifies the user when the connection is restored
.EXAMPLE
    .\Notify-InternetConnectionRestored.ps1 -NotificationTitle "Connection Restored" -NotificationMessage "You are back online!" -NotificationLogo "$HOME\Pictures\Icons\wifi-green.png"
    Continuously checks for the internet connection to "www.google.com"
    every 30 seconds and notifies the user with a custom title, message and logo when the connection is restored
.NOTES
    This script requires either 'wintoast' (Windows), 'notify-send' (Linux) or the 'BurntToast' PowerShell module (Windows) for notifications.
    Please ensure that one of these is installed and available in the system PATH for notifications to work.
#>

param (
    # The target website to check for internet connection (default: "www.google.com")
    [string] $TargetName = "www.google.com",

    # Title of the notification
    [string] $NotificationTitle = "Internet Connection Restored",

    # Message of the notification
    [string] $NotificationMessage = "The internet connection is back up and running!",

    # Notification image/logo
    [string] $NotificationLogo = "$HOME\Pictures\Icons\wifi-white.png",

    # The interval in seconds between each connection check (default: 30)
    [int]$Interval = 30
)

Write-Host "Checking for Internet connectivity..."

# Main loop to continuously check for the internet connection
while ($True) {
    # Check if the internet connection is restored
    $Connection = Test-Connection -TargetName $TargetName -Count 1 -Quiet

    if ($Connection -eq $true) {
        # Internet connection is restored. Notify the user and exit the loop
        Write-Host "Internet Connection Restored" -ForegroundColor Green
        
        # Notify the user
        if (Get-Command wintoast -ErrorAction SilentlyContinue) {
            wintoast --title $NotificationTitle --message $NotificationMessage --logo $NotificationLogo
        }
        elseif (Get-Command notify-send -ErrorAction SilentlyContinue) {
            notify-send $NotificationTitle $NotificationMessage -i $NotificationLogo
        }
        elseif (Get-Module -ListAvailable -Name BurntToast) {
            $NotificationParams = @{
                Text    = @($NotificationTitle, $NotificationMessage)
                AppLogo = (Resolve-Path $NotificationLogo).Path 
            }
            New-BurntToastNotification @NotificationParams
        }
        else {
            Write-Warning "No supported notification tool found. Please install 'wintoast', 'notify-send' or the 'BurntToast' PowerShell module for notifications."
            Write-Host "`a $NotificationTitle - $NotificationMessage" -ForegroundColor Green
        }

        # Exit the loop
        break
    }

    # Wait for the specified interval before checking again
    Start-Sleep -Seconds $Interval
}
