---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatWorkingFolder

## SYNOPSIS

Gets the working folder for packages.

## SYNTAX

```Powershell
Get-AatWorkingFolder
```

## DESCRIPTION

Gets the working folder for packages. This defaults to the the current working folder  
unless explicitly set using *Set-AatWorkingFolder*.

## EXAMPLES

### Example 1: Get the working folder

```Powershell
PS C:\> Get-AatWorkingFolder
C:\aat-package-examples\
```

<!--## PARAMETERS-->

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.String

<!--## NOTES-->

## RELATED LINKS

[Set-AatWorkingFolder](.)