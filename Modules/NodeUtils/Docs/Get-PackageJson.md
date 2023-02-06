---
external help file: NodeUtils-help.xml
Module Name: NodeUtils
online version:
schema: 2.0.0
---

# Get-PackageJson

## SYNOPSIS
Get the contents of a package.json file

## SYNTAX

```
Get-PackageJson [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get the contents of a package.json file

## EXAMPLES

### EXAMPLE 1
```
Get-PackageJson
Get the contents of the package.json file in the current directory
```

### EXAMPLE 2
```
Get-PackageJson -Path "C:\Projects\MyProject"
Get the contents of the package.json file in the given directory
```

### EXAMPLE 3
```
Get-PackageJson -Path "C:\Projects\MyProject\package.json"
Get the contents of the package.json file in the given path
```

## PARAMETERS

### -Path
The path to the package.json file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Join-Path -Path $PWD.Path -ChildPath "package.json")
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
