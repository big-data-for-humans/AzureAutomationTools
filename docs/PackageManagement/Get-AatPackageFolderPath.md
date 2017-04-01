---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatPackageFolderPath

## SYNOPSIS
Gets the specified package folder path.

## SYNTAX

### Assets
```
Get-AatPackageFolderPath [-Assets] [<CommonParameters>]
```

### Modules
```
Get-AatPackageFolderPath [-Modules] [<CommonParameters>]
```

### Runbooks
```
Get-AatPackageFolderPath [-Runbooks] [<CommonParameters>]
```

## DESCRIPTION
Gets the specifed package folder path - this is a concatenation of Get-WorkingFolder and Get-WorkingPackage as well as the specified folder (Assets, Modules or Runbooks).

## EXAMPLES

### Example 1: Get Assets folder path
```
PS C:\> Get-AatPackageFolderPath -Assets
C:\aat-package-examples\example-1\assets
```

### Example 2: Get Modules folder path
```
PS C:\> Get-AatPackageFolderPath -Modules
C:\aat-package-examples\example-1\Modules
```

### Example 3: Get Runbooks folder path
```
PS C:\> Get-AatPackageFolderPath -Runbooks
C:\aat-package-examples\example-1\Runbooks
PS C:\>
```

## PARAMETERS

### -Assets
Return the Assets folder path.

```yaml
Type: SwitchParameter
Parameter Sets: Assets
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Modules
Return the Modules folder path.

```yaml
Type: SwitchParameter
Parameter Sets: Modules
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Runbooks
Return the Runbooks folder path.

```yaml
Type: SwitchParameter
Parameter Sets: Runbooks
Aliases: 

Required: True
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

[Get-AatWorkingFolder](.)

[Get-AatWorkingPackage](.)

[Set-AatWorkingFolder](.)

[Set-AatWorkingPackage](.)
