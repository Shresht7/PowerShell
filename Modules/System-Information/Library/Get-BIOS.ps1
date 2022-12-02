function Get-BIOS() {
    Get-CimInstance -ClassName Win32_BIOS
}
