---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Set-AatWorkingFolder

## SYNOPSIS
Sets the working packages folder

## SYNTAX

```
Set-AatWorkingFolder -Path <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the working packages folder, this folder will continue to be used regardless of pwd

## EXAMPLES

### Example 1: Set the working folder
```PowerShell
PS C:\> Set-AatWorkingFolder -Path c:\aat-package-examples
```

## PARAMETERS

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

### -Path
Specifies the path to set as the working folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Get-AatWorkingFolder](.)


