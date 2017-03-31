---
external help file: AzureAutomationTools.PackageManagement-help.xml
online version: 
schema: 2.0.0
---

# New-AatAutomationPackage

## SYNOPSIS

Creates a new package in the package working folder.

## SYNTAX

```Powershell
New-AatAutomationPackage [-Name] <String> [-DontCreateAssetsFile] [-IncludeSamples] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Creates a new package in the package working folder set using *Set-AatWorkingFolder*. If the folder already exists in the package working folder then it miust be empty or package creation fails. The folders and files created depend on the current package options

## EXAMPLES

### Example 1: Create a new package

```Powershell
PS C:\> Set-AatWorkingPackage -PackageName aat-package-examples
PS C:\> New-AatAutomationPackage -Name example-1
PS C:\> ls (Join-Path -Path (Get-AatWorkingFolder) -ChildPath 'example-1') -Recurse

    Directory: C:\aat-package-examples\example-1


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       31/03/2017     07:54                assets
d-----       30/03/2017     20:57                modules
d-----       30/03/2017     20:57                runbooks


    Directory: C:\aat-package-examples\example-1\assets


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       30/03/2017     20:57            102 assets.json

```

### Example 2: Create a new package without the default assets file

```Powershell
PS C:\> New-AatAutomationPackage -Name example-2 -DontCreateAssetsFile
```

### Example 3: Create a new package with samples

```Powershell
PS C:\> New-AatAutomationPackage -Name example-3  -IncludeSamples
```

### Example 4: Create a new package with custom options

## PARAMETERS

```Powershell
PS C:\> if(-not (Test-Path -Path .\aat-package-examples\)){md .\aat-package-examples\}
PS C:\> Set-AatPackageOption -AssetsFolderName af -ModulesFolderName mf -RunbooksFolderName rf -AssetsFileName a.json
PS C:\> New-AatAutomationPackage -Name example-4

PS C:\> ls (Join-Path -Path (Get-AatWorkingFolder) -ChildPath 'example-4') -Recurse


    Directory: C:\aat-package-examples\example-4


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       31/03/2017     08:49                af
d-----       31/03/2017     08:49                mf
d-----       31/03/2017     08:49                rf


    Directory: C:\aat-package-examples\example-4\af


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       31/03/2017     08:49            102 a.json


PS C:\>

```

### -Name

The name of the package to create

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DontCreateAssetsFile

{{Fill DontCreateAssetsFile Description}}

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

### -IncludeSamples

Include samples in the newly created package. 

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

### System.Object

<!--## NOTES-->

## RELATED LINKS

[Add-AatVariableDefinition](.)
 
[Set-AatWorkingFolder](.)

[Get-AatPackageOption](.)

[Set-AatPackageOption](.)