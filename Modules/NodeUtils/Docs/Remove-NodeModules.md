---
external help file: NodeUtils-help.xml
Module Name: NodeUtils
online version:
schema: 2.0.0
---

# Remove-NodeModules

## SYNOPSIS
Remove the node_modules folder from the given path

## SYNTAX

```
Remove-NodeModules [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove the node_modules folder from the given path

## EXAMPLES

### EXAMPLE 1
```
Remove-NodeModules
Interactively select a folder to remove the node_modules folder from
```

### EXAMPLE 2
```
Remove-NodeModules -Path "C:\Projects\MyProject"
Remove the node_modules folder from the given directory
```

### EXAMPLE 3
```
Remove-NodeModules -Path "C:\Projects\MyProject\node_modules"
Remove the node_modules folder from the given path
```

## PARAMETERS

### -Path
The path to the folder containing the node_modules folder to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (
            Get-ChildItem -Directory -Path $PWD.Path |
            Where-Object { Test-Path -Path (Join-Path -Path $_.FullName -ChildPath "node_modules") } |
            Invoke-Fzf -Multi `
                -Preview "pwsh -NoProfile -Command Get-Size -Path {}\node_modules" `
                -Header "Select a folder to remove the node_modules folder from"
        )
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
