---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Get-AatPackageOption

## SYNOPSIS
Gets the current package options.

## SYNTAX

```
Get-AatPackageOption [<CommonParameters>]
```

## DESCRIPTION
Gets the current package options e.g. AssetsFolderName, AssetsFileName, JsonAssetDepth.

## EXAMPLES

### Example 1: Get options
```PowerShell
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

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None (does not accept pipeline input)

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

[Set-AatPackageOption](.)
