---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatWorkingFolder

## SYNOPSIS
Gets the working folder for packages.

## SYNTAX

```
Get-AatWorkingFolder [<CommonParameters>]
```

## DESCRIPTION
Gets the working folder for packages. This defaults to the the current working folder  
unless explicitly set using *Set-AatWorkingFolder*.

## EXAMPLES

### Example 1: Get the working folder
```
PS C:\> Get-AatWorkingFolder
C:\aat-package-examples\
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

[Set-AatWorkingFolder](.)