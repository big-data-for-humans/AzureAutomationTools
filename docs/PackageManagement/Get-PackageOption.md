---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-PackageOption

## SYNOPSIS
Gets the current package options

## SYNTAX

```
Get-PackageOption
```

## DESCRIPTION
Gets the current package options e.g.
AssetsFolderName, AssetsFileName, JsonAssetDepth

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-AatPackageOption
```

Name                           Value                                                                                                                     
----                           -----                                                                                                                     
JsonAssetDepth                 4                                                                                                                         
RunbooksFolderName             runbooks                                                                                                                  
ModulesFolderName              modules                                                                                                                   
Encoding                       UTF8                                                                                                                      
AssetsFolderName               assets                                                                                                                    
AssetsFileName                 assets.json

## PARAMETERS

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

