---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# New-AatAssetsFile

## SYNOPSIS

Creates a new assets file in the assets folder for the working package.

## SYNTAX

### ChooseAssets

```Powershell
New-AatAssetsFile [-Name <String>] [-IncludeVariables] [-IncludeCredentials [-IncludeCertificates] [-IncludeConnections] [-WhatIf] [-Confirm]
```

### AllAssets

```Powershell
New-AatAssetsFile [-Name <String>] [-All] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Creates a new assets file in the assets folder for the working package. This can optionally be created with entries for the different supported types of assets.

## EXAMPLES

### Example 1: Create an assets file for all asset types

```Powershell
PS C:\> New-AatAssetsFile -Name all-assets.json -All
```

This will create the file *all-assets.json* in the package assets folder.

### Example 2: Create an assets file just for variables

```Powershell
PS C:\> New-AatAssetsFile -Name variables-assets.json -IncludeVariables
```

This will create the file *variables-assets.json* in the package assets folder.

### Example 3: Create an assets file for variables and creentials

```Powershell
PS C:\> New-AatAssetsFile -Name variables-and-credential-assets.json -IncludeVariables -IncludeCredentials
```

This will create the file *variables-and-credential-assets.json* in the package assets folder.

### Example 4: Create an empty assets file

```Powershell
PS C:\> New-AatAssetsFile -Name empty.json
```

This will create the file *empty.json* in the package assets folder.

## PARAMETERS

### -Name

The name of the assets file to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCertificates

Create an placeholder for certificates in the newly created file.

```yaml
Type: SwitchParameter
Parameter Sets: ChooseAssets
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeConnections

Create an placeholder for connections in the newly created file.

```yaml
Type: SwitchParameter
Parameter Sets: ChooseAssets
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCredentials

Create an placeholder for credentials in the newly created file.

```yaml
Type: SwitchParameter
Parameter Sets: ChooseAssets
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeVariables

Create an placeholder for variables in the newly created file.

```yaml
Type: SwitchParameter
Parameter Sets: ChooseAssets
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All

Create an placeholder for all asset types in the newly created file.

```yaml
Type: SwitchParameter
Parameter Sets: AllAssets
Aliases: 

Required: True
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

## INPUTS

### None

## OUTPUTS

### System.Object

<!--## NOTES-->

## RELATED LINKS

[New-AatAutomationPackage](.)

[Add-AatVariableDefinition](.)

