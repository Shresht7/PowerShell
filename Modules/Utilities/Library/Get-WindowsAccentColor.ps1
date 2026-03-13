<#
.SYNOPSIS
    Retrieves the current Windows accent color.
.DESCRIPTION
    This function reads the accent color from the Windows registry and returns it in various formats.
.PARAMETER As
    Specifies the format in which to return the accent color. Valid options are:
    - "Color": Returns a System.Drawing.Color object (default).
    - "Hex": Returns a hexadecimal string in the format RRGGBB.
    - "Hexa": Returns a hexadecimal string in the format AARRGGBB.
    - "RGB": Returns a custom object with R, G, and B properties.
    - "RGBA": Returns a custom object with A, R, G, and B properties.
.EXAMPLE
    Get-WindowsAccentColor
    Returns the accent color as a System.Drawing.Color object.
.EXAMPLE
    Get-WindowsAccentColor -As Hex
    Returns the accent color as a hexadecimal string in the format #RRGGBB.
.EXAMPLE
    Get-WindowsAccentColor -As RGB
    Returns the accent color as a custom object with R, G, and B properties.
.EXAMPLE
    Get-WindowsAccentColor -As Hexa
    Returns the accent color as a hexadecimal string in the format #AARRGGBB.
.EXAMPLE
    Get-WindowsAccentColor -As RGBA
    Returns the accent color as a custom object with A, R, G, and B properties.
#>
function Get-WindowsAccentColor {
    [CmdletBinding()]
    param(
        # Specifies the format in which to return the accent color.
        # Default is "Color" which returns a System.Drawing.Color object.
        [Parameter()]
        [ValidateSet("Color", "Hex", "Hexa", "RGB", "RGBA")]
        [string] $As = "Color"
    )

    # If not on windows, return a warning and exit
    if ($PSVersionTable.Platform -ne "Win32NT") {
        Write-Warning "This function is only for Windows"
        return $null
    }

    # Get the accent color from the registry
    $dwmAccent = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -ErrorAction SilentlyContinue
    if (-not $dwmAccent) {
        Write-Warning "Failed to retrieve the accent color from the registry"
        return $null
    }

    # Convert the DWORD value to ARGB components
    $raw = [uint32]$dwmAccent.AccentColor
    $bytes = [BitConverter]::GetBytes($raw)
    $A = $bytes[3]; $R = $bytes[2]; $G = $bytes[1]; $B = $bytes[0]

    # Create a Color object from the ARGB components
    $color = [System.Drawing.Color]::FromArgb($A, $R, $G, $B)

    # Return the color in the requested format
    switch ($As) {
        "Color" { return $color }
        "Hexa" { return "#{0:X2}{1:X2}{2:X2}{3:X2}" -f $A, $R, $G, $B }  # AARRGGBB
        "Hex" { return "#{0:X2}{1:X2}{2:X2}" -f $R, $G, $B }            # RRGGBB
        "RGB" { return [PSCustomObject]@{ R = $R; G = $G; B = $B } }
        "RGBA" { return [PSCustomObject]@{ A = $A; R = $R; G = $G; B = $B } }
        default { return $color }
    }
}
