---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatPackageOption

## SYNOPSIS

Gets the current package options.

## SYNTAX

```Powershell
Get-AatPackageOption
```

## DESCRIPTION

Gets the current package options e.g. AssetsFolderName, AssetsFileName, JsonAssetDepth.

## EXAMPLES

### Example 1: Get options

```Powershell
PS C:> Get-AatPackageOption

Name                           Value
----                           -----
JsonAssetDepth                 4
RunbooksFolderName             runbooks
ModulesFolderName              modules
Encoding                       UTF8
AssetsFolderName               assets
AssetsFileName                 assets.json

```

<!--## PARAMETERS-->

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

[Set-AatPackageOption](.)
