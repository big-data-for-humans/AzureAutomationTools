---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Set-WorkingPackage

## SYNOPSIS
Sets the working package.

## SYNTAX

```
Set-WorkingPackage [-PackageName] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Sets the working package - this must be a folder in the working package folder

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-AatWorkingPackage -PackageName sample
```

## PARAMETERS

### -PackageName
{{Fill PackageName Description}}

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

### System.String

## NOTES

## RELATED LINKS

