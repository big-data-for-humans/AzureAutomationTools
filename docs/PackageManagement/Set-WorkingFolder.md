---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Set-WorkingFolder

## SYNOPSIS
Sets the working packages folder

## SYNTAX

```
Set-WorkingFolder [-Path] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Sets the working packages folder, this folder will continue to be used regardless of pwd

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-AatWorkingFolder -Path c:\aat-package-examples
```

## PARAMETERS

### -Path
{{Fill Path Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
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

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### None

## NOTES

## RELATED LINKS

