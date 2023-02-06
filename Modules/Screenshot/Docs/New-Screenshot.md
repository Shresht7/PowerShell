---
external help file: Screenshot-help.xml
Module Name: Screenshot
online version:
schema: 2.0.0
---

# New-Screenshot

## SYNOPSIS
Capture a screenshot

## SYNTAX

```
New-Screenshot [[-Folder] <String>] [[-Name] <String>] [-Open]
```

## DESCRIPTION
Captures a screenshot and save it on disk

## EXAMPLES

### EXAMPLE 1
```
New-Screenshot
Captures a screenshot and saves it to the screenshot folder
```

### EXAMPLE 2
```
New-Screenshot -Open
Captures a screenshot and opens it with default application
```

## PARAMETERS

### -Folder
The path to the screenshot folder

```yaml
Type: String
Parameter Sets: (All)
Aliases: Path, Destination, DestinationFolder, Target

Required: False
Position: 1
Default value: $Script:ScreenshotFolder
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The screenshot's filename

```yaml
Type: String
Parameter Sets: (All)
Aliases: Item, File, Screenshot

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Open
Open the screenshot

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
