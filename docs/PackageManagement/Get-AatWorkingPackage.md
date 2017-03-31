---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatWorkingPackage

## SYNOPSIS
Gets the working package.

## SYNTAX

```
Get-AatWorkingPackage [<CommonParameters>]
```

## DESCRIPTION
Gets the working package, or if none has been set returns the first folder in
the working package folder (i.e. as returned by Get-AatWorkingFolder)

## EXAMPLES

### Example 1: Get the working package
```
PS C:\> Get-AatWorkingPackage
example-1
```

<!--## PARAMETERS-->

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.String
<!--## NOTES-->

## NOTES

## RELATED LINKS

[Get-AatWorkingFolder](.)
