---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Test-AatAutomationPackage

## SYNOPSIS
Tests an automation package.

## SYNTAX

```
Test-AatAutomationPackage [-PackageName <String>] [-IgnoreWarnings] [<CommonParameters>]
```

## DESCRIPTION
Tests an automation package. If no package name is specified then the current working package will be tested.

## EXAMPLES

### Example 1: Test the current working package
```
PS C:\> Test-AatAutomationPackage

Message                                                                Severity
-------                                                                --------
Assets file 'assets.json' does not contain any of the supported prop   Error
No module defintions found in  'C:\aat-package-examples\bad\modules'   Warning
No runbooks found in  'C:\aat-package-examples\bad\runbooks'           Warning
```

### Example 2: Test the current working package and ignore warnings
```
PS C:\> Test-AatAutomationPackage -IgnoreWarnings

Message                                                                Severity
-------                                                                --------
Assets file 'assets.json' does not contain any of the supported prop   Error
```

### Example 3: Test a specified package
```
PS C:\> Test-AatAutomationPackage -PackageName example-3

Message                                                                Severity
-------                                                                --------
Assets file 'assets.json' does not contain any of the supported prop   Error
No runbooks found in  'C:\aat-package-examples\bad\runbooks'           Warning
```

## PARAMETERS

### -IgnoreWarnings
Specifies that warnings should note be reported.

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

### -PackageName
Specifies the name of the package to test.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PackageTestResult
<!--## NOTES-->

<!--## RELATED LINKS-->

## NOTES

## RELATED LINKS

