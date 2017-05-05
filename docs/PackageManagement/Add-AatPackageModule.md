---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# Add-AatPackageModule

## SYNOPSIS
Adds a module to a module package file.

## SYNTAX

### WithoutPackage (Default)
```
Add-AatPackageModule [-Name <String>] [-Version <String>] [<CommonParameters>]
```

### WithPackage
```
Add-AatPackageModule [-Name <String>] [-Version <String>] [-Package] <String> [<CommonParameters>]
```

## DESCRIPTION
Adds a module to a module package file created using the **New-AatModulesFile** Cmdlet.


See **New-AatModulesFile** for help on creating the package files.

## EXAMPLES

*These examples require an understanding of module files. For more information about modules files, please see help for New-AatModulesFile*

### Example 1: Add a module to a modules file
```powershell
PS C:\> Add-AatPackageModule -Name 'AzureRm.Profile' -ModuleFile 'awesome-modules'
```

Adds the latest version of *AzureRm.Profile* to the modules file *awesome-modules*.

### Example 2: Add a specific version of a module to a modules file
```powershell
PS C:\> Add-AatPackageModule -Name 'AzureRm.Profile' -Version '2.8.0' -ModuleFile 'awesome-modules'
```

Adds version 2.8.0 of *AzureRm.Profile* to the modules file *awesome-modules*.

### Example 2: Add a custom module to a modules file
```powershell
PS C:\> Add-AatPackageModule -Name 'AzureRm.Profile' -Package 'https://awesomestorageaccount.blob.core.windows.net/awesomecontainer/AwesomeModule.zip' -ModuleFile 'awesome-modules'
```

Adds the custom package to the modules file *awesome-modules*.

## PARAMETERS

### -Name
The name of the module to add

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

### -Package
The blob storage location of the package. If Package is not specified it is searched for and populated from PSGallery.

```yaml
Type: String
Parameter Sets: WithPackage
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version of the package. If package is not specified this will dictate what package is found from PSGallery. If Package is specified this is used for version tracking and updating. If package and version are not specified, the latest version will be added from PSGallery.

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

### System.Object

## NOTES

## RELATED LINKS

