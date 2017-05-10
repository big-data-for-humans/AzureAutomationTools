---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# New-AatModulesFile

## SYNOPSIS
Creates a new modules file in the modules folder of the working package.

## SYNTAX

```
New-AatModulesFile -Name <String> [-IncludeSamples] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new modules file in the assets folder of the working package. This can optionally be created with samples using the -IncludeSamples parameter.

## EXAMPLES

### Example 1: Create a modules file
```
PS C:\> New-AatModulesFile -Name 'awesome-modules'
```

This will create the file *awesome-modules.json* in the package modules folder.

### Example 2: Create a modules file and add a custom module
```
PS C:\> New-AatModulesFile -Name 'awesome-modules'
PS C:\> Add-AatPackageModule -Name 'AwesomeModule' -Package 'https://awesomestorageaccount.blob.core.windows.net/awesomecontainer/AwesomeModule.zip'
```

This will create the file *awesome-modules.json* in the package modules folder and add a custom module to it.

*For more information please see the help for Add-AatPackageModule*

### Example 3: Create a modules file and add a module from PSGallery
```
PS C:\> New-AatModulesFile -Name 'awesome-modules'
PS C:\> Add-AatPackageModule -Name 'AzureRm.Compute'
```

This will create the file *awesome-modules.json* in the package modules folder and add the latest version of AzureRm.Compute and all its dependencies.

*For more information please see the help for Add-AatPackageModule*

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

### -Force
Force the creation of the file even if the file exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSamples
Include samples in the file creation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the modules file to create.

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

### None

## OUTPUTS

### System.IO.Path

## NOTES

## RELATED LINKS

