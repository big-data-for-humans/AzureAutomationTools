---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatWorkingPackage

## SYNOPSIS

Gets the working package.

## SYNTAX

```Powershell
Get-AatWorkingPackage
```

## DESCRIPTION

Gets the working package, or if none has been set returns the first folder in
the working package folder (i.e. as returned by Get-AatWorkingFolder)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```Powershell
PS C:\> Get-AatWorkingPackage
example-1
```

<!--## PARAMETERS-->

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.String

<!--## NOTES-->

## RELATED LINKS

[Get-AatWorkingFolder](.)
