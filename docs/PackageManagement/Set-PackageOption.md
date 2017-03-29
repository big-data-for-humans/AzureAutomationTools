---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Set-PackageOption

## SYNOPSIS
Sets the current package options

## SYNTAX

```
Set-PackageOption [[-AssetsFolderName] <String>] [[-ModulesFolderName] <String>]
 [[-RunbooksFolderName] <String>] [[-AssetsFileName] <String>] [[-JsonAssetDepth] <Int32>]
 [[-Encoding] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Gets the current package options e.g.
AssetsFolderName, AssetsFileName, JsonAssetDepth

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-AatPackageOption -AssetsFolderName example-assets
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-AatPackageOption -AssetsFileName example-assets.json
```

### -------------------------- EXAMPLE 3 --------------------------
```
Set-AatPackageOption -ModulesFolderName example-modules
```

### -------------------------- EXAMPLE 4 --------------------------
```
Set-AatPackageOption -RunbooksFolderName example-runbooks
```

### -------------------------- EXAMPLE 5 --------------------------
```
Set-AatPackageOption -Encoding UTF8
```

### -------------------------- EXAMPLE 6 --------------------------
```
Set-AatPackageOption -AssetsFolderName example-assets -AssetsFileName example-assets.json -ModulesFolderName example-modules -RunbooksFolderName example-runbooks -Encoding UTF8
```

## PARAMETERS

### -AssetsFolderName
The name of the folder to use for assets

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModulesFolderName
The name of the folder to use for modules

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunbooksFolderName
The name of the folder to use for runbooks

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetsFileName
The name of the file to use for assets

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonAssetDepth
The maximum depth to resolve objects when converting them to json.
Default 4

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
The encoding to use when writing files.
Suported values are UTF8 & Unicode.
Default UTF8

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
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

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

