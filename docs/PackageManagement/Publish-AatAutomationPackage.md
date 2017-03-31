---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Publish-AutomationPackage

## SYNOPSIS

Deploys automation resources: runbooks, modules and assets (variables & credentials)

## SYNTAX

```
Publish-AutomationPackage [-ResourceGroupName] <String> [-AutomationAccountName] <String> [[-Paths] <String[]>]
 [-DeployRunbooks] [-DeployModules] [-DeployVariables] [-DeployCredentials] [-NewCredentialsOnly]
 [[-JsonAssetDepth] <Int32>] [[-RunbookFilter] <String>] [[-AssetsFilter] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Deploys automation resources: runbooks, modules and assets (variables & credentials) to an automation
account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Publish-AutomationPackage
```

## PARAMETERS

### -ResourceGroupName
{{Fill ResourceGroupName Description}}

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
{{Fill AutomationAccountName Description}}

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
Deploys runbooks.
Default is false

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
Deploys modules.
Default is false

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
Deploys assets.
Default is false

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
Deploys credentials.
Default is false

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
Deploys only new credentials, if DeployCredentials is specified.
Default is false

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
Override this if the nested level is greather than 4 (count the curly braces).
Default is 4

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
{{Fill RunbookFilter Description}}

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
Filter for Assets - Default *.json

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

## OUTPUTS

## NOTES

## RELATED LINKS

