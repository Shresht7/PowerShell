# -----------
# Backup-Item
# -----------

<#
.SYNOPSIS
Creates a backup of the given item
.DESCRIPTION
Creates a backup-copy of the given item in the specified backup folder (default: $HOME/Archives/Backups).
By default, a .zip archive is created with the backup contents but you can also ask it to copy the item as is.
.EXAMPLE
Backup-Item important-file.txt
Creates an archive (.zip) backup of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Copy -Name important-file.txt
Create a copy of the important-file.txt in the default backup folder
.EXAMPLE
Backup-Item -Type Archive -Name important-folder -BackupPath "$HOME/NewBackup"
Creates an archive (.zip) backup of the important-folder in the user defined "$HOME/NewBackup" folder
.EXAMPLE
Backup-Item important-file.txt -HashAlgorithm MD5
Use MD5 algorithm to compute the hash of the backup file
#>
function Backup-Item {

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "MEDIUM")]
    Param (
        # The item to backup
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript({ Test-Path -IsValid $_ })]
        [Alias("Item", "Name", "Input")]
        [string] $Path,

        # The type of backup to create. "Archive" to create a .zip file or "Copy" to copy the contents as is
        [ValidateSet("Archive", "Copy")]
        [Alias("BackupType")]
        [string] $Type = "Archive",

        # The algorithm to use to compute the file hash
        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [Alias("Algorithm", "Hash", "Checksum", "ChecksumAlgorithm")]
        [string] $HashAlgorithm = "SHA256",
    
        # Path to the backup directory
        [ValidateScript({ Test-Path $_ })]
        [Alias("Output", "DestinationPath")]
        [string] $BackupPath = $Script:BACKUP_PATH,

        # Metadata file - keeps a log of the backup operations
        [Alias("LogFilePath")]
        [string] $MetadataFilePath = (Join-Path $Script:BACKUP_PATH "__BACKUPS__.csv")
    )
    
    Begin {
        # Create the Backup Directory if it doesn't exist
        if (-Not (Test-Path -Path $BackupPath -PathType Container)) {
            try {
                Write-Verbose "Creating $BackupPath"
                $null = New-Item -ItemType Directory $BackupPath -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to create the backup directory: $($_.Exception.Message)"
                return
            }
        }
    }
    
    Process {
        # Gather Information
        $OriginalPath = Get-Item -LiteralPath $Path
        if (-Not $OriginalPath) {
            Write-Error "The specified item to backup does not exist. Please provide a valid item."
            return
        }
        $Item = Get-Item -Path $OriginalPath
        $Date = Get-Date -Format FileDateTimeUniversal

        # Determine Destination
        $DestFolder = Join-Path $BackupPath $Item.BaseName
        $Destination = Join-Path $DestFolder "$Date`_$($Item.Name)$(if ($Type -eq "Archive") { ".zip" })"
        
        # Create the destination if it doesn't already exist
        if (-Not (Test-Path -Path $DestFolder)) {
            try {
                Write-Verbose "Creating $DestFolder"
                $null = New-Item -ItemType Directory $DestFolder -Force -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to create the backup destination directory: $($_.Exception.Message)"
                return
            }
        }

        # Check Should Process and exit if false
        if (-Not $PSCmdlet.ShouldProcess($Destination, "Backing up $Path to $Destination")) { return }
        
        # Perform Backup Operation
        switch ($Type) {
            "Archive" {
                Write-Verbose "Archiving $Path`t-->`t$Destination"
                $null = Compress-Archive -Path $Path -CompressionLevel Optimal -DestinationPath $Destination
                break
            }
            "Copy" {
                Write-Verbose "Copying $Path`t-->`t$Destination"
                $null = Copy-Item -Path $Path -Destination $Destination -Recurse
                break
            }
        }

        # Get file hash of the produced backup
        $Hash = Get-FileHash -Path $Destination
        
        # Create the output object
        $Output = [PSCustomObject]@{
            Date        = Get-Date
            Name        = $Path
            Source      = $OriginalPath
            Destination = $Destination
            Algorithm   = $Hash.Algorithm
            Hash        = $Hash.Hash   
        }

        # Write information to a csv file
        $Output | Export-Csv -Path $MetadataFilePath -Append

        return $Output
    }

    End { }
}
