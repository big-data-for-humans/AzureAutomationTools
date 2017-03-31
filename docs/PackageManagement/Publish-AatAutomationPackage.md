---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Publish-AutomationPackage

## SYNOPSIS

Publish automation resources: runbooks, modules and assets (variables & credentials)

## SYNTAX

```
Publish-AutomationPackage [-ResourceGroupName] <String> [-AutomationAccountName] <String> 
[[-Paths] <String[]>] [-DeployRunbooks] [-DeployModules] [-DeployVariables] [-DeployCredentials] [-NewCredentialsOnly]
[[-JsonAssetDepth] <Int32>] [[-RunbookFilter] <String>] [[-AssetsFilter] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Publish automation resources: runbooks, modules and assets (variables & credentials) to an automation
account.

## EXAMPLES 1: Publish all packages 

```Powershell
PS C:\> Publish-AatAutomationPackage -ResourceGroupName rg -AutomationAccountName aa 
```

## PARAMETERS

### -ResourceGroupName

Name of resource group to publish to.

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

### -AutomationAccountName

Name of automation account to publish to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Paths

The paths to deploy - if ommitted all folders at the root level (except deploy) will be searched for the specified
automation resources.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
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

### -JsonAssetDepth

The depth to use when converting objects to json.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 4
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
Position: 5
Default value: *.ps1
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetsFilter

Only assets in files matching the filter will be published.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: *.json
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

### None

## OUTPUTS

### None

<!--## NOTES-->

<!--## RELATED LINKS-->

