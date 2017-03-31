---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# New-AatVariableDefinition

## SYNOPSIS

Creates a new variable.

## SYNTAX

### Plain

```Powershell
New-AatVariableDefinition [-Name <String>] -Value <Object> [-AsJson] [-WhatIf] [-Confirm]
```

### Encrypted

```Powershell
New-AatVariableDefinition [-Name <String>] [-IsEncrypted] [-AsJson] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Creates a new variable.

## EXAMPLES

### Example 1: Create a variable

```Powershell
PS C:\> New-AatVariableDefinition -Name var -Value 1

Name IsEncrypted Value
---- ----------- -----
var        False     1
```

### Example 2: Create an encrypted variable

```Powershell
PS C:\> New-AatVariableDefinition -Name var -IsEncrypted

Name IsEncrypted Value
---- ----------- -----
var         True
```

Note: Values are not supported for encypted variables. These must be set securely after publishing.

### Example 3: Create a variable as json

```Powershell
PS C:\> New-AatVariableDefinition -Name var -Value 1 -AsJson
{
    "Name":  "var",
    "IsEncrypted":  false,
    "Value":  1
}
```

## PARAMETERS

### -Name

Specifies the name of the variable.

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

### -Value

Specifies the value of the variable.

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

### -IsEncrypted

Specifies that the variable is encrypted.

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

### -AsJson

Specifies that the variable is returned as json instead of PSCustomObject.

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

### System.Management.Automation.PSCustomObject

### System.String

<!--## NOTES-->

<!--## RELATED LINKS-->

