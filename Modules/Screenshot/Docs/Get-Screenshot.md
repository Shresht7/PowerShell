---
external help file: Screenshot-help.xml
Module Name: Screenshot
online version:
schema: 2.0.0
---

# Get-Screenshot

## SYNOPSIS
Returns a list of all screenshots

## SYNTAX

```
Get-Screenshot [[-Path] <String>] [[-Filter] <String>]
```

## DESCRIPTION
Returns a list of all screenshots

## EXAMPLES

### EXAMPLE 1
```
Get-Screenshot
Returns the list of all screenshots
```

### EXAMPLE 2
```
Get-Screenshot | Invoke-Fzf | Invoke-Item
Returns the list of all screenshots and opens the selected one
```

### EXAMPLE 3
```
Get-Screenshot | Sort-Object -Property LastWriteTime | Select-Object -First 1 | Invoke-Item
Opens the latest screenshot with the default application
```

## PARAMETERS

### -Filter
Filter the list of screenshots

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The folder where the screenshots are stored

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder, Source, FolderPath

Required: False
Position: 1
Default value: $Script:ScreenshotFolder
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
