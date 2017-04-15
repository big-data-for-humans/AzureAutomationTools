# Table of Contents

<!-- toc -->
- [Package Management](#package-management)

<!-- tocstop -->

# Package Management

Package Management helps you create packages of automation resources and deploy them

A package consists of related
- runbooks
- modules
- variables
- credentials

Note: support for *certificates* & *connections* will be added soon.

## Installation

### From the Powershell Gallery 

```Powershell
    Install-Module -Name AzureAutomationTools.PackageManagement
```
#### Requirements

Windows Powershell 5.1 (only tested with 5.1.14393.953)

## Create a package

You can create a new package in the current folder.

```Powershell
    New-AatAutomationPackage -Name 'monkey'
```

This will create the following:

```Powershell
    .\monkey
    .\monkey\assets
    .\monkey\modules
    .\monkey\runbooks
    .\monkey\assets\assets.json    

```

The file assets.json contains

```JSON
    {
        "Credentials": [],
        "Variables": []
    }
```

### Sample files

Specifying the **-IncludeSamples** switch will create sample files in the package

```Powershell
    New-AatAutomationPackage -Name 'monkey' -IncludeSamples
```

will additionally create 

```Powershell
    .\monkey\assets\sample-assets.json    

```

sample-assets.json will contains something similar to:

```JSON
    {
        "Credentials": [
            {
                "Name": "ExampleCredential",
                "Username": "user@exmaple.com"
            }
        ],
        "Variables": [
            {
                "Name": "simple-plaintext-variable",
                "IsEncrypted": false,
                "Value": "lorem"
            },
            {
                "Name": "simple-encrypted-variable",
                "IsEncrypted": true,
                "Value": null
            },
            {
                "Name": "object-variable",
                "IsEncrypted": false,
                "Value": {
                    "ComplexProperty": {
                        "Ipsum": 1,
                        "Dolor": "monkey"
                    },
                    "SimpleProperty": "Lorem"
                }
            }
        ]
    }
```

## Variables
You can add variables to an assets file manually but to avoid errors you can do the following

```Powershell
    Add-AatVariableDefinition -Name 'bert' -Value 'ernie'    
```

```JSON
    {
        "Credentials": [],
        "Variables": [
            {
                "Name": "bert",
                "IsEncrypted": false,
                "Value": "ernie"
            }
        ]
    }
```
## Credentials

Credentials must be added manually to an assets file.

```JSON
    {
        "Credentials": [],
        "Variables": []
    }
```

e.g.

```JSON
    {
        "Credentials": [
            {
                "Name" :  "ExampleCredential",
                "UserName" : "user@example.com"    
            }
        ],
        "Variables": []
    }
```

## Test a package

You can test a package by executing:

```Powershell

    Test-AatAutomationPackage

```

which will give output similar to:

```
    Message                                           Severity
    -------                                           --------
    No module defintions found in  '.\monkey\modules' Warning
    No runbooks found in  '.\monkey\runbooks'         Warning
```


## Publish a package

To publish all package in the current folder

```Powershell
    
    $Params = @{        
        ResourceGroupName = "rg";
        AutomationAccountName = "aa";
        DeployRunbooks = $true;
        DeployModules = $true;
        DeployVariables = $true;
        DeployCredentials = $true;
        NewCredentialsOnly = $true;
    }

    Publish-AatAutomationPackage @Params

```

To publish only the *monkey* package

```Powershell
    
    $Params = @{        
        ResourceGroupName = "rg";
        AutomationAccountName = "aa";
        DeployRunbooks = $true;
        DeployModules = $true;
        DeployVariables = $true;
        DeployCredentials = $true;
        NewCredentialsOnly = $true;
    }

    Publish-AatAutomationPackage @Params -PackageName 'monkey'

```