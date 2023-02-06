---
external help file: AutoComplete-help.xml
Module Name: AutoComplete
online version:
schema: 2.0.0
---

# Register-CommandCompleter

## SYNOPSIS
Register a command completer

## SYNTAX

```
Register-CommandCompleter [-Name] <String> [[-Tooltip] <String>] [-Completions <Completion[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Register a command completer.
The script block starts by tracking the current command selection in the $COMMANDS tree object,
then filters the completions that match the word to complete and returns them as CompletionResult objects.

## EXAMPLES

### EXAMPLE 1
```
Register-CommandCompleter -Name 'git' -Tooltip 'git source control' -Completions @(
    [Completion]::new('add', 'Add file contents to the index'),
    [Completion]::new('branch', 'List, create, or delete branches', @(
        [Completion]::new('-a', 'List both remote-tracking branches and local branches'),
        [Completion]::new('-d', 'Delete fully merged branch'),
        [Completion]::new('-D', 'Delete branch (even if not merged)'),
    )),
)
```

## PARAMETERS

### -Completions
The completions object

```yaml
Type: Completion[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the command

```yaml
Type: String
Parameter Sets: (All)
Aliases: Command

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tooltip
The tooltip to display

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
