---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Add-AatPackageVariable

## SYNOPSIS
Adds a variable defintion to an assets file.

## SYNTAX

### Plain
```
Add-AatPackageVariable -Name <String> -Value <Object> [-AssetsFileName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Encrypted
```
Add-AatPackageVariable -Name <String> [-IsEncrypted] [-AssetsFileName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Adds a variable defintion to an assets file, by default this use the default assests file for the project, but can be overriden by specifying the name of another assets file.

## EXAMPLES

### Example 1: Add a plaintext variable
```PowerShell
PS> Add-AatPackageVariable -Name 'plain-value' -Value 'some value'
```

Adds the variable *plain-value* to the default assets file.

### Example 2: Add a enrypted variable
```PowerShell
PS> Add-AatPackageVariable -Name 'encrypted-value' -IsEncrypted
```

Adds the variable *encrypted-value* to the default assets file.

### Example 3: Add a plaintext variable to a specific assets file
```PowerShell
PS> Add-AatPackageVariable -Name 'simple-value' -Value 'some-value' -AssetsFileName some-assets
```

Adds the varaible *simple-value* to the *some-assets* assets file.

### Example 4: Add a complex variable
```PowerShell
PS> $ObjectVariable = [pscutomobject]@{StringProperty = 'lorem'; IntProperty = 1; ObjectProperty = [pscutomobject]@{StringProperty='Ipsum';FloatProperty = 17.3}
    PS> Add-AatPackageVariable -Name 'complex-value' -Value $ObjectVariable
```

Adds the varaible *complex-value* to the default assets file.

## PARAMETERS

### -AssetsFileName
The name of an assets file. This must already exist in the package assets folder.

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

### -IsEncrypted
Adds an encrypted variable.

Note: settings a value is not supported with encrpyted value - these must be securely set after publishing.

```yaml
Type: SwitchParameter
Parameter Sets: Encrypted
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the variable. Must be unique in the assets file.

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

### -Value
The value of the variable. Can be a simple type or complex object. Complex objects are converted to json.

```yaml
Type: Object
Parameter Sets: Plain
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

### System.Object

## NOTES

## RELATED LINKS

[New-AatAssetsFile](.)
