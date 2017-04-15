---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Publish-AatAutomationPackage

## SYNOPSIS
Publish automation resources: runbooks, modules and assets (variables & credentials)

## SYNTAX

### NamedPackages (Default)
```
Publish-AatAutomationPackage -ResourceGroupName <String> -AutomationAccountName <String> [-DeployRunbooks]
 [-DeployModules] [-DeployVariables] [-DeployCredentials] [-NewCredentialsOnly] [-JsonAssetDepth <Int32>]
 [-RunbookFilter <String>] [-AssetsFileFilter <String>] [-PackageName <String[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### AllPackages
```
Publish-AatAutomationPackage -ResourceGroupName <String> -AutomationAccountName <String> [-DeployRunbooks]
 [-DeployModules] [-DeployVariables] [-DeployCredentials] [-NewCredentialsOnly] [-JsonAssetDepth <Int32>]
 [-RunbookFilter <String>] [-AssetsFileFilter <String>] [-AllPackages] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Publish automation resources: runbooks, modules and assets (variables & credentials) to an automation
account.

## EXAMPLES

### Example 1: Publish all packages
```PowerShell
PS C:\> Publish-AatAutomationPackage -ResourceGroupName rg -AutomationAccountName aa -AllPackages
```

## PARAMETERS

### -AutomationAccountName
Name of automation account to publish to.

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

### -DeployCredentials
Publish credentials.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployModules
Publish modules.


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployRunbooks
Publish runbooks.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployVariables
Publish assets.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonAssetDepth
The depth to use when converting objects to json.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 4
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewCredentialsOnly
Publish only new credentials.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of resource group to publish to.

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

### -RunbookFilter
Only runbooks matching the filter will be published.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: *.ps1
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

### -AllPackages
Deploys all packages in the current working folder.

```yaml
Type: SwitchParameter
Parameter Sets: AllPackages
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetsFileFilter
Filter to apply to assets files. Default *.json.

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

### -PackageName
Name of the package to deploy.

```yaml
Type: String[]
Parameter Sets: NamedPackages
Aliases: 

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

### None

## NOTES

## RELATED LINKS

