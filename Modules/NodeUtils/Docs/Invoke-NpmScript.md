---
external help file: NodeUtils-help.xml
Module Name: NodeUtils
online version:
schema: 2.0.0
---

# Invoke-NpmScript

## SYNOPSIS
Invoke an npm script

## SYNTAX

```
Invoke-NpmScript [[-Name] <String>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke an npm script from a package.json file

## EXAMPLES

### EXAMPLE 1
```
Invoke-NpmScript
Invoke an npm script from the package.json file in the current directory
```

### EXAMPLE 2
```
Invoke-NpmScript -Path "C:\Projects\MyProject"
Invoke an npm script from the package.json file in the given directory
```

## PARAMETERS

### -Name
Name of the npm script to invoke

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path
Path to the package.json file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $PWD.Path
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
