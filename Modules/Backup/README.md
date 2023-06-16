# `Backup`

This module provides cmdlets for managing backups using PowerShell.

<!--

---

## 📘 Installation

To install the `Backup` module, open a PowerShell session and run the following command:

```powershell
Install-Module -Name BackupManagement
``` 

-->

---

## 📋 Cmdlets

The `BackupManagement` module contains the following cmdlets:

- `Backup-Item`: Creates a backup of a specified item.
- `Get-Backup`: Retrieves the list of backups.
- `Remove-OldBackup`: Removes old backups based on specified criteria.
- `Restore-ItemFromBackup`: Restores an item from a backup.
- `Backup-Status`: Gets the status of backups.

---

## 📘 Usage

1. Import the module:

   ```powershell
   Import-Module -Name Backup
   ```

2. Create a backup:

   ```powershell
   Backup-Item -Path "C:\Data\Documents" -BackupPath "C:\Backups"
   ```

3. Retrieve the list of backups:

   ```powershell
   Get-Backup -BackupPath "C:\Backups"
   ```

4. Remove old backups:

   ```powershell
   Remove-OldBackup -Age 30 -BackupPath "C:\Backups"
   ```

5. Restore an item from a backup:

   ```powershell
   Restore-ItemFromBackup -Name "README.md" -Path "C:\Restored" -BackupPath "C:\Backups"
   ```

6. Get the status of backups:

   ```powershell
   Backup-Status -BackupPath "C:\Backups"
   ```

> **Note**: Ensure that you provide valid paths for the backup and destination folders.

---

## 📕 Reference

### `Backup-Item`

Creates a backup of a specified item.

#### Parameters

- **Path**: The path to the item to be backed up.
- **BackupPath**: The path to the backup folder.

### `Get-Backup`

Retrieves the list of backups.

#### Parameters

- **BackupPath**: The path to the backup folder.

### `Remove-OldBackup`

Removes old backups based on specified criteria.

#### Parameters

- **Age**: The number of days specifying the age of backups to be removed.
- **BackupPath**: The path to the backup folder.

### `Restore-ItemFromBackup`

Restores an item from a backup.

#### Parameters

- **Name**: The name of the item to be restored.
- **Path**: The path to restore the item to.
- **BackupPath**: The path to the backup folder.

### `Backup-Status`

Gets the status of backups.

#### Parameters

- **BackupPath**: The path to the backup folder.

---


