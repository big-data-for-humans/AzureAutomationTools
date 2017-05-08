Set-StrictMode -Version latest

$ErrorActionPreference = 'Stop'

Set-Variable -Scope Script -Name 'VariablesPropertyName' -Option 'Constant' -Value 'Variables'
Set-Variable -Scope Script -Name 'CredentialsPropertyName' -Option 'Constant' -Value 'Credentials'
Set-Variable -Scope Script -Name 'ConnectionsPropertyName' -Option 'Constant' -Value 'Connections'
Set-Variable -Scope Script -Name 'CertificatesPropertyName' -Option 'Constant' -Value 'Certificates'

$Script:Options = @{
    AssetsFolderName = 'assets'
    ModulesFolderName = 'modules'
    RunbooksFolderName = 'runbooks'    
    AssetsFileName = 'assets.json'
    JsonAssetDepth = 4
    Encoding = 'UTF8'
}

$Script:WorkingFolder = ''
$Script:WorkingPackage = ''

class PackageTestResult {
    [ValidateNotNullOrEmpty()]        
    [string] $Message     
    [ValidateSet('Error', 'Warning')]
    [string] $Severity
    
    PackageTestResult (
        [string] $Message,    
        [string] $Severity        
    ) {
        $this.Message = $Message
        $this.Severity = $Severity
    }
}

function Get-AatWorkingFolder {
    $ret = $Script:WorkingFolder 

    if (-not $Script:WorkingFolder) {
        throw "Working folder not set. Please set using Set-AatWorkingFolder." 
    }

    $ret
}

function Set-AatWorkingFolder {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path                
    )

    if ($PSCmdlet.ShouldProcess("$Path", 'Set working folder' )) {            
        $Script:WorkingFolder = (Resolve-Path -Path $Path).Path
    }
}

function Get-AatWorkingPackage {
    [CmdletBinding(PositionalBinding = $false)]
    param()    
    
    $ret = $Script:WorkingPackage

    if (-not $Script:WorkingPackage) {        
        Write-Verbose -Message "No working package set - using first folder in $Script:WorkingFolder"
        $ret = (Get-ChildItem -Directory -Path (Get-AatWorkingFolder) | Sort-Object Name | Select-Object -First 1 -ExpandProperty Name)
    }

    $ret
}

function Set-AatWorkingPackage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$PackageName                
    )

    if ($PSCmdlet.ShouldProcess("$PackageName", 'Set working package' )) {            
        if (-not (Test-Path -Path (Join-path -Path (Get-AatWorkingFolder) -ChildPath $PackageName))) {
            throw "Cannot set working package to [$PackageName] - the folder does not exist in [$(Get-AatWorkingFolder)]"
        }    

        $Script:WorkingPackage = $PackageName
    }
}

function Set-AatPackageOption {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$AssetsFolderName,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ModulesFolderName,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$RunbooksFolderName,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$AssetsFileName,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$JsonAssetDepth,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Unicode', 'UTF8')]
        [string]$Encoding        
    )

    if ($PSCmdlet.ShouldProcess("", 'Set package option' )) {            
        if ($AssetsFolderName) {
            $Script:Options.AssetsFolderName = $AssetsFolderName
        }

        if ($AssetsFileName) {
            $Script:Options.AssetsFileName = $AssetsFileName
        }

        if ($ModulesFolderName) {
            $Script:Options.ModulesFolderName = $ModulesFolderName
        }

        if ($RunbooksFolderName) {
            $Script:Options.RunbooksFolderName = $RunbooksFolderName
        }

        if ($AssetsFileName) {
            $Script:Options.AssetsFilter = $AssetsFileName
        }

        if ($JsonAssetDepth) {
            $Script:Options.JsonAssetDepth = $JsonAssetDepth
        }

        if ($Encoding) {
            $Script:Options.Encoding = $Encoding
        }    
    }
}


function Get-AatPackageOption {
    [OutputType('System.Collections.HashTable')] 
    [CmdletBinding(PositionalBinding = $false)]
    param()    
    
    $Script:Options
}

function Get-AatPackagePath {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [string]$PackageName
    )    
    
    $WorkingFolderPath = Get-AatWorkingFolder

    if (-not $PackageName) {
        $PackageName = Get-AatWorkingPackage
    }
    
    $PackagePath = (Join-Path -Path $WorkingFolderPath -ChildPath $PackageName)
    $PackagePath
}

function Get-AatPackageFolderPath {    
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Assets')]
        [switch]$Assets,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Modules')]
        [switch]$Modules,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Runbooks')]
        [switch]$Runbooks,

        [ValidateNotNullOrEmpty()]
        [string]$PackageName
    )

    $ret = $null

    if (-not $PackageName) {
        $PackagePath = Get-AatPackagePath
    } 
    else {
        $PackagePath = Get-AatPackagePath -PackageName $PackageName
    }

    
    $FolderName = $null
    
    switch ($true) {
        $Assets.IsPresent { $FolderName = $Script:Options.AssetsFolderName }
        $Modules.IsPresent { $FolderName = $Script:Options.ModulesFolderName }
        $Runbooks.IsPresent { $FolderName = $Script:Options.RunbooksFolderName }
        Default {throw 'Unknown package folder.'}
    }

    if ($FolderName -eq '.') {
        $ret = $PackagePath
    }
    else {
        $ret = (Join-Path -Path $PackagePath -ChildPath $FolderName)
    }

    $ret
}

function New-AatAutomationPackage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    param (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,        
        [Switch]$DontCreateAssetsFile,
        [Switch]$IncludeSamples
    )
    
    if ($PSCmdlet.ShouldProcess("$Name", 'Create automation package' )) {                        
        $Path = Get-AatWorkingFolder
                    
        Write-Verbose "Creating package folder [$Name] in '$Path' ..."
        
        $RootPath = (Join-Path -Path $Path -ChildPath $Name)
                
        if (Test-Path -Path $RootPath) {
            if ((Get-ChildItem -Path $RootPath)) {
                throw "Cannot create package folder - path [$RootPath] aleady exists and is not empty."
            } 
        }
        else {
            New-Item -Path $RootPath -ItemType 'Directory' | Out-Null
        }
        
        Set-AatWorkingPackage -PackageName $Name

        $AssetsPath = Get-AatPackageFolderPath -Assets        
        $ModulesPath = Get-AatPackageFolderPath -Modules
        $RunbooksPath = Get-AatPackageFolderPath -Runbooks

        $AssetsPath, $ModulesPath, $RunbooksPath | ForEach-Object {
            if ($_ -ne $RootPath) {
                Write-Verbose -Message "Creating folder '$_' ..."
                        
                New-Item $_ -ItemType 'Directory' | Out-Null
                
                Write-Verbose -Message "Creating folder '$_' - done."
            }
        }
        
        if (-not $DontCreateAssetsFile.IsPresent) {
            New-AatAssetsFile -Name $Script:Options.AssetsFileName -IncludeVariables -IncludeCredentials
        }

        if ($IncludeSamples.IsPresent) {
            Write-Verbose "Creating samples ..."
            
            $SampleAssetsFileName = 'sample-assets.json'         
            New-AatAssetsFile -Name $SampleAssetsFileName -All
            Add-AatPackageVariable -AssetsFileName $SampleAssetsFileName -Name 'simple-plaintext-variable'  -Value 'lorem'
            Add-AatPackageVariable -AssetsFileName $SampleAssetsFileName -Name 'simple-encrypted-variable'  -IsEncrypted
            $Object = @{
                SimpleProperty = 'Lorem'
                ComplexProperty = @{
                    Ipsum = 1
                    Dolor = 'monkey'
                }
            }
            Add-AatPackageVariable -AssetsFileName $SampleAssetsFileName -Name 'object-variable' $Object
            Write-Verbose "Creating samples - done."
        }

        Write-Verbose "Creating package folder [$Name] in '$Path' - done"    
    }
}

function Test-AatAutomationPackage {
    [CmdletBinding(PositionalBinding = $false)]
    param(    
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PackageName,
        [switch]$IgnoreWarnings
    )

    [PackageTestResult[]]$TestResults = @()
    $WorkingFolder = Get-AatWorkingFolder

    Write-Verbose -Message "Working folder: '$WorkingFolder)'"    

    if (-not $PackageName) {
        $PackageName = Get-AatWorkingPackage
    }

    Write-Verbose -Message "Testing package: [$PackageName]"

    Write-Verbose -Message 'Testing package folders ...'

    $AssetsPath = Get-AatPackageFolderPath -Assets -PackageName $PackageName

    if (-not (Test-Path -Path $AssetsPath)) {
        $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Package folder [Assets] '$AssetsPath' not found", 'Error'
    }

    $ModulesPath = Get-AatPackageFolderPath -Modules -PackageName $PackageName

    if (-not (Test-Path -Path $ModulesPath)) {
        $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Package folder [Modules] '$ModulesPath' not found", 'Error'
    }
    
    $RunbooksPath = Get-AatPackageFolderPath -Runbooks -PackageName $PackageName

    if (-not (Test-Path -Path $RunbooksPath)) {
        $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Package folder [Runbooks] '$RunbooksPath' not found", 'Error'
    }
    
    Write-Verbose -Message "Testing package folders - done."

    Write-Verbose -Message "Testing assets ..."

    $AssetsFilePath = (Join-Path -Path $AssetsPath -ChildPath $Script:Options.AssetsFileName)

    if (Test-Path -Path $AssetsPath) {
        if (-not ((Test-Path $AssetsFilePath) -or $IgnoreWarnings.IsPresent)) {
            $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Assets file '$AssetsFilePath' not found", 'Warning'
        }

        Get-ChildItem -Path $AssetsPath -File | ForEach-Object {
            $AssetsFilePath = $_.FullName
            
            Write-Verbose "Testing assets file '$AssetsFilePath' ..." 

            $Assets = Get-Content -Raw -Path $AssetsFilePath | ConvertFrom-Json -ErrorAction Ignore

            if (-not $Assets) {
                $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Assets file '$AssetsFilePath' does not contain valid json", 'Error'
            }
            else {
                [string[]]$ExpectedProperties = 'Certificates', 'Credentials', 'Variables', 'Connections'
                [string[]]$Properties = @()
                $Properties += $Assets.psobject.Properties | Select-Object -ExpandProperty Name                
                $Intersection = (Compare-Object -ReferenceObject $ExpectedProperties -DifferenceObject $Properties -IncludeEqual -ExcludeDifferent)
                
                if (-not $Intersection) {
                    $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Assets file '$AssetsFilePath' does not contain any of the supported properties ('Certificates', 'Credentials', 'Variables', 'Connections')", 'Error'
                }

                $UnsupportedProperties = (Compare-Object -ReferenceObject $ExpectedProperties -DifferenceObject $Properties | Where-Object SideIndicator -EQ '=>')
                
                $UnsupportedProperties | ForEach-Object {
                    $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Assets file '$AssetsFilePath' contains unsupported property [$($_.InputObject)]", 'Error'
                }                
                
                if ($Assets.psobject.properties | Where-Object Name -eq 'Variables') {
                    $i = 0

                    $Assets.Variables | ForEach-Object {
                        $i++
                        if (-not ($_.psobject.properties | Where-Object Name -eq 'Name')) {
                            $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Variable definition [$i] in '$AssetsFilePath' missing required property [Name]", 'Error'                    
                        }

                        if (-not ($_.psobject.properties | Where-Object Name -eq 'Value')) {
                            $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Variable definition [$i] in '$AssetsFilePath' missing required property [Value]", 'Error'                    
                        }

                        if (-not ($_.psobject.properties | Where-Object Name -eq 'IsEncrypted')) {
                            $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Variable definition [$i] in '$AssetsFilePath' missing required property [IsEncrypted]", 'Error'                    
                        }
                    
                        ($_.psobject.properties | Where-Object Name -notin 'Name', 'Value', 'IsEncrypted' | Select-Object -ExpandProperty 'Name') | ForEach-Object {
                            $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Variable definition [$i] in '$AssetsFilePath' contains unsupported property [$_]", 'Error'
                        }
                    }
                    
                    $Assets.Variables | Where-Object {$_.psobject.Properties.name -eq 'Name'} |  Select-Object -ExpandProperty 'Name' | Group-Object  | Where-Object Count -GT 1 | ForEach-Object {
                        $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Assets file '$AssetsFilePath' contains duplicate defintion of variable [$_]", 'Error'
                    }                    
                }
            }     

            Write-Verbose "Testing assets file '$AssetsFilePath' - done."             
        }
    }

    Write-Verbose -Message "Testing modules ..."
    
    if (Test-Path -Path $ModulesPath) {
        $ModuleFiles = (Get-ChildItem -Path $ModulesPath -File)

        if (-not $ModuleFiles) {
            if (-not $IgnoreWarnings.IsPresent) {
                $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "No module defintions found in  '$ModulesPath'", 'Warning'
            }
        }
        else {
            $ModuleFiles | ForEach-Object {
                $ModulesFilePath = $_.FullName
                $Modules = Get-Content -Raw -Path $ModulesFilePath | ConvertFrom-Json -ErrorAction Ignore

                if (-not $Modules) {
                    $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "Modules file '$ModulesFilePath' does not contain valid json.", 'Error'                    
                }                
            }
        }
    }
    
    Write-Verbose -Message "Testing modules - done."

    Write-Verbose -Message "Testing runbooks ..."
    
    if (Test-Path -Path $RunbooksPath) {
        $RunbookFiles = (Get-ChildItem -Path $RunbooksPath -File)

        if (-not $RunbookFiles) {
            if (-not $IgnoreWarnings.IsPresent) {
                $TestResults += New-Object -TypeName PackageTestResult -ArgumentList "No runbooks found in  '$RunbooksPath'", 'Warning'
            }
        }
    }
    
    Write-Verbose -Message "Testing modules - done."
    
    $TestResults
}

function New-AatAssetsFile {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Mandatory = $false, ParameterSetName = 'ChooseAssets')]
        [switch]$IncludeVariables,
        [Parameter(Mandatory = $false, ParameterSetName = 'ChooseAssets')]
        [switch]$IncludeCredentials,
        [Parameter(Mandatory = $false, ParameterSetName = 'ChooseAssets')]
        [switch]$IncludeCertificates,
        [Parameter(Mandatory = $false, ParameterSetName = 'ChooseAssets')]
        [switch]$IncludeConnections,
        [Parameter(Mandatory = $true, ParameterSetName = 'AllAssets')]
        [switch]$All
    )
    if (-not $Name) {
        $Name = $Script:Options.AssetsFileName
    }

    if ($PSCmdlet.ShouldProcess("$Name", 'Create assets file' )) {                        
        $Assets = @{}

        if ($All.IsPresent -or $IncludeVariables.IsPresent) {
            $Assets.Add($Script:VariablesPropertyName, @())
        }

        if ($All.IsPresent -or $IncludeCredentials.IsPresent) {
            $Assets.Add($Script:CredentialsPropertyName, @())
        }

        if ($All.IsPresent -or $IncludeCertificates.IsPresent) {
            $Assets.Add($Script:CertificatesPropertyName, @())
        }

        if ($All.IsPresent -or $IncludeConnections.IsPresent) {
            $Assets.Add($Script:ConnectionsPropertyName, @())
        }
        
        $AssetsFilePath = Join-Path -Path (Get-AatPackageFolderPath -Assets) -ChildPath $Name

        Write-Verbose -Message "Creating assets file '$AssetsFilePath' ..."

        if (Test-Path $AssetsFilePath) {
            throw "Cannot create assets file - file '$AssetsFilePath' already exists."
        }
        else {
            $Assets | ConvertTo-Json -Depth ($Script:Options.JsonAssetDepth + 2) | Out-File -Encoding $Script:Options.Encoding  -FilePath $AssetsFilePath
        }

        Write-Verbose -Message "Creating assets file '$AssetsFilePath' - done."
    }
}

function New-AatPackageVariable {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]    
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Mandatory = $true, ParameterSetName = 'Plain')]
        [ValidateNotNullOrEmpty()]
        [Object]$Value,
        [Parameter(Mandatory = $true, ParameterSetName = 'Encrypted')]        
        [switch]$IsEncrypted,
        [switch]$AsJson
    )
    
    if ($PSCmdlet.ShouldProcess("$Name", 'Create variable definition' )) {         
        $Variable = [pscustomobject]@{
            Name = $Name
            IsEncrypted = $IsEncrypted.IsPresent
            Value = $Value
        }             

        $ret = $Variable

        if ($AsJson.IsPresent) {
            $ret = $ret | ConvertTo-Json -Depth $Script:Options.JsonAssetDepth
        }                
        
        $ret
    }
}

function Add-AatPackageVariable {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]    
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,        
        [Parameter(Mandatory = $true, ParameterSetName = 'Plain')]
        [ValidateNotNullOrEmpty()]
        [object]$Value,
        [Parameter(Mandatory = $true, ParameterSetName = 'Encrypted')]        
        [switch]$IsEncrypted,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$AssetsFileName              
    )

    if ($PSCmdlet.ShouldProcess("$Name", 'Add variable definition' )) {         
        $NewVariableParams = @{
            Name = $Name
        }

        if ($PsCmdlet.ParameterSetName -eq 'Plain') {
            $NewVariableParams.Add('Value', $Value)
        }

        if ($PsCmdlet.ParameterSetName -eq 'Encrypted') {
            $NewVariableParams.Add('IsEncrypted', $IsEncrypted.IsPresent)
        }
        
        $Variable = New-AatPackageVariable @NewVariableParams

        Write-verbose -Message "Working folder: '$(Get-AatWorkingFolder)'"
        Write-verbose -Message "Working package: [$(Get-AatWorkingPackage)]"

        if (-not $AssetsFileName) {
            $AssetsFileName = $Script:Options.AssetsFileName
        }
        
        Write-verbose -Message "Assets file: [$AssetsFileName]"
        
        $AssetsFolderPath = (Get-AatPackageFolderPath -Assets)
        $AssetsFilePath = Join-Path -Path $AssetsFolderPath -ChildPath $AssetsFileName

        Write-verbose -Message "Assets file path: '$AssetsFilePath'"

        $Assets = Get-Content -Raw -Path $AssetsFilePath | ConvertFrom-Json

        if (($Assets.Variables | Where-Object Name -eq $Name)) {
            throw "Cannot add variable [$Name], '$AssetsFilePath' already contains a definition for [$Name]."        
        }
        
        $Assets.Variables += $Variable
        $Json = $Assets | ConvertTo-Json -Depth ($Script:Options.JsonAssetDepth + 2)
        $Json | Out-File -FilePath $AssetsFilePath -Encoding $Script:Options.Encoding 
    }
}

function New-AatModulesFile {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [switch]$IncludeSamples,

        [Parameter()]
        [switch]$Force
    )

    if ($PSCmdlet.ShouldProcess($Name, "Create modules file")) {
        $Content = [System.Collections.Generic.List[hashtable]]::new()

        if ($IncludeSamples.IsPresent) {
            Write-Output "`n`tAzureRm.Profile has been added to the example using the `"Add-AatPackageModule -Name 'AzureRM.Profile' -Version '2.7.0'`" cmdlet." | Out-Default
            $Content += @(
                [ordered]@{
                    Name = 'AzureRm.Profile'
                    Version = '2.7.0'
                    Package = 'https://devopsgallerystorage.blob.core.windows.net/packages/azurerm.profile.2.7.0.nupkg'
                },
                [ordered]@{
                    Name = 'AwesomeModule'
                    Package = 'https://awesomestorageaccount.blob.core.windows.net/awesomecontainer/AwesomeModule.zip'
                }
            )
        }

        $FilePath = Join-Path -Path (Get-AatPackageFolderPath -Modules) -ChildPath "$Name.json"
        New-Item -Path $FilePath -Force:$Force
        if ($Content.Count -gt 0) {
            $Content | ConvertTo-Json | Set-Content -Path $FilePath
        }
        else {
            Set-Content -Path $FilePath -Value '[]'
        }
    }
}

function Add-AatPackageModule {
    [CmdletBinding(DefaultParameterSetName = 'WithoutPackage')]
    param (
        [Parameter(Mandatory = $true,
                    Position = 2)]
        [Parameter(ParameterSetName = 'WithoutPackage')]
        [Parameter(ParameterSetName = 'WithPackage')]
        [string]
        $Name,

        [Parameter(Mandatory = $false,
                    Position = 3)]
        [Parameter(ParameterSetName = 'WithoutPackage')]
        [Parameter(ParameterSetName = 'WithPackage')]
        [string]
        $Version,

        [Parameter(Mandatory = $true,
                    Position = 4,
                    ParameterSetName = 'WithPackage')]
        [string]
        $Package
    )

    dynamicparam{
        #create a new ParameterAttribute Object
        $ModuleFileAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ModuleFileAttribute.Position = 1
        $ModuleFileAttribute.Mandatory = $true
        $ModuleFileAttribute.HelpMessage = "Name of the module file to add the module to"

        $ValidateNotNullOrEmptyAttribute = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

        $ValidateSetAttribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList (
            Get-ChildItem -Path (Get-AatPackageFolderPath -Modules) -Filter '*.json' | %{$_.Name -replace '.json', ''}
        )

        #create an Attributecollection object for the attribute we just created.
        $AttributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]

        #add our custom attribute
        $AttributeCollection.Add($ModuleFileAttribute)
        $AttributeCollection.Add($ValidateSetAttribute)
        $AttributeCollection.Add($ValidateNotNullOrEmptyAttribute)

        #add our paramater specifying the attribute collection
        $ModuleFileParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ModuleFile', [string], $AttributeCollection)

        #expose the name of our parameter
        $ParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $ParamDictionary.Add('ModuleFile', $ModuleFileParam)
        return $ParamDictionary
    }

    begin {
        $ModuleFileName = $PSBoundParameters.ModuleFile
    }

    end {
        if ($ModuleFileName -notmatch "^*/.json$") {
            $ModuleFileName += '.json'
        }

        $ModuleFilePath = Join-Path -Path (Get-AatPackageFolderPath -Modules) -ChildPath $ModuleFileName
        $ModuleFileObj = Get-Content -Raw -Path $ModuleFilePath | 
            ConvertFrom-Json

        if ($PSCmdlet.ParameterSetName -eq 'WithoutPackage') {
            $ModuleObj = GetModuleBlob -ModuleList @{Name = $Name; Version = $Version}
        } 
        else {
            $ModuleObj = @{
                Name = $Name
                Version = $Version
                Package = $Package
            }
        }

        $Names = $ModuleObj | ForEach-Object {$_.Name}
        $CurrentEntries = $ModuleFileObj | Where-Object {$_.Name -in $Names}
        if ($CurrentEntries) {
            $BadEntries = @()
            $GoodEntries = @()
            $CurrentEntries | ForEach-Object {
                $ExistingObj = $ModuleObj | Where-Object Name -eq $_.Name

                if ($ExistingObj -and $_.Version -ne $ExistingObj.Version) {
                    $BadEntries += "[$($_.Name)](Expected: $($ExistingObj.Version), Actual: $($_.Version))"
                }
                else {
                    Write-Verbose -Message "Duplicate entry of $($_.Name) : $($_.Version). Skipping."
                    $GoodEntries += $_.Name
                }
            }

            if ($BadEntries.Count -gt 0) {
                throw "Module version descrepency found: $([string]::join('; ', $BadEntries)). Please remove these modules from the modules file and try again."
            }  
            else {
                $ModuleObj = $ModuleObj | Where-Object Name -NotIn $GoodEntries
            }
        }

        $ModuleFileObj + $ModuleObj | ConvertTo-Json | Set-Content -Path $ModuleFilePath
    }
}

function DeployRunbooks {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^.*\.ps1$')]        
        [string]$Filter
    )

    $RunbooksRoot = Join-Path -Path $Path -ChildPath 'runbooks'

    Write-Verbose -Message "Runbooks Root: '$RunbooksRoot'"

    if (-not (Test-Path $RunbooksRoot)) {
        throw "Path not found: '$RunbooksRoot'"
    }

    $CommonParameters = @{ResourceGroupName = $ResourceGroupName; AutomationAccountName = $AutomationAccountName}

    $Runbooks = Get-ChildItem -Path $RunbooksRoot -File -Filter $Filter

    if (-not $Runbooks) {
        Write-Warning -Message "No runbooks found in $RunbooksRoot matching $Filter"    
    }

    $Runbooks | ForEach-Object {
        $CommonParameters
        
        $ExistingRunbooks = @()
        $ExistingRunbooks += (Get-AzureRmAutomationRunbook @CommonParameters| Select-Object Name) | ForEach-Object {$_.Name}
        
        if ($ExistingRunbooks.Contains($_.BaseName)) {
            Write-Output "Removing existing runbook $($_.BaseName) ..."
            
            Remove-AzureRmAutomationRunbook @CommonParameters -Name $_.BaseName -Force
            
            Write-Output "Removing existing runbook $($_.BaseName) - done."
        }
        
        Write-Output "Importing runbook $($_.BaseName) ..."
        
        Import-AzureRmAutomationRunbook -Name $_.BaseName -Type 'PowerShell' -Path $_.FullName -Published @CommonParameters 
        
        Write-Output "Importing runbook $($_.BaseName) - done."
    }
}

function DeployAssets {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^.*\.json$')]        
        [string]$Filter         
    )

    $AssetsRoot = Join-Path -Path $Path -ChildPath 'assets'
    
    Write-Output "Assets Root: '$AssetsRoot'"    
    Write-Output "Filter: [$Filter]"

    if (-not (Test-Path $AssetsRoot)) {
        throw "Path not found: '$AssetsRoot'"
    }
    
    $CommonParameters = @{ResourceGroupName = $ResourceGroupName; AutomationAccountName = $AutomationAccountName}

    Get-ChildItem -Path $AssetsRoot -File -Filter $Filter | ForEach-Object {
        Write-Output "Assets File: '$($_.FullName)'"
        #Write-Output (Get-Content $_.FullName -Raw) 
        $Assets = Get-Content $_.FullName -Raw | ConvertFrom-Json
                
        $ExistingVariables = @()
        $ExistingVariables += (Get-AzureRmAutomationVariable @CommonParameters| Select-Object Name) | ForEach-Object {$_.Name}
    
        if ($DeployVariables) {
            $Assets.Variables | ForEach-Object {
                if ($_.IsEncrypted) {
                    $Value = 'totally not the value!'
                }
                elseif (('Int32', 'Boolean', 'String', 'Double').Contains($_.Value.GetType().Name)) {
                    $Value = $_.Value
                }
                else {
                    $Value = $_.Value | ConvertTo-Json -Depth $JsonAssetDepth
                }
            
                $Params = @{Name = $_.Name; Encrypted = $_.IsEncrypted; Value = $Value}
                $Params += $CommonParameters

                if ($ExistingVariables.Contains($_.Name)) {
                    Write-Output "Updating existing variable [$($_.Name)] ..."

                    Set-AzureRmAutomationVariable @Params

                    Write-Output "Updating existing variable [$($_.Name)] - done."

                }
                else {
                    Write-Output "Creating new variable [$($_.Name)] .."

                    New-AzureRmAutomationVariable @Params

                    Write-Output "Creating new variable [$($_.Name)] - done."
                }
                
                if ($_.IsEncrypted) {
                    Write-Warning "Password must be manually set for variable [$($_.Name)]"
                }
            }
        }
        
        if ($DeployCredentials) {
            if ($Assets.psobject.properties.Name -notcontains 'Credentials') {
                Write-Warning "No credentials found in [$($_.FullName)]."
            }
            else { 
                $ExistingCredentials = @()
                $ExistingCredentials += (Get-AzureRmAutomationCredential @CommonParameters| Select-Object Name) | ForEach-Object {$_.Name}

                $Assets.Credentials | ForEach-Object {
                    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/574 
                    #$Password = [guid]::NewGuid() | ConvertTo-SecureString -asPlainText -Force
                    $Password = [SecureString]::new()
                    (New-Guid).Guid.ToCharArray() | ForEach-Object {$Password.AppendChar($_)} # i.e. definitely not the password
                    $Username = $_.Username
                    $Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
                    $Params = @{Name = $_.Name; Value = $Credential; }
                    $Params += $CommonParameters

                    if ($ExistingCredentials.Contains($_.Name)) {
                        if ($NewCredentialsOnly) {
                            Write-Output "Skipping existing credential [$($_.Name)]."
                        }
                        else {
                            Write-Output "Updating existing credential [$($_.Name)] ..."

                            Set-AzureRmAutomationCredential @Params 

                            Write-Output "Updating existing credential [$($_.Name)] - done."
                            Write-Warning "Password must be manually set for credential $($_.Name)"
                        }
                    }
                    else {
                        Write-Output "Creating new credential [$($_.Name)] ..."

                        New-AzureRmAutomationCredential @Params
                    
                        Write-Output "Creating new credential [$($_.Name)] - done."
                        Write-Warning "Password must be manually set for credential [$($_.Name)]"
                    }
                }
            }        
        }
    }
}

function DeployModules {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$MaxModulePoll = 100
    )

    $ModulesRoot = Join-Path -Path $Path -ChildPath 'modules'

    if (-not (Test-Path $ModulesRoot)) {
        throw "Path not found: '$ModulesRoot'"
    }

    Write-Output "Modules Root: '$ModulesRoot'"
    
    $ModulesFiles = Get-ChildItem -Path $ModulesRoot -File -Filter '*.json' 

    if (-not $ModulesFiles) {
        Write-Warning -Message "No modules files found in $ModulesRoot matching '*.json'"
    }

    $CommonParameters = @{ResourceGroupName = $ResourceGroupName; AutomationAccountName = $AutomationAccountName};

    $ModulesFiles | ForEach-Object {
        Write-Output "Modules file: '$($_.FullName)'";
        $Modules = Get-Content $_.FullName -Raw | ConvertFrom-Json;
        $ExistingModules = (Get-AzureRmAutomationModule @CommonParameters| Select-Object 'Name', 'Version');
            
        foreach ($Module in $Modules) {
            $ContentLink = $Module.Package
            $Params = @{Name = $Module.Name;}
            $Params += $CommonParameters
            $AutomationModule = $null
            
            try {
                $ExistingModule = Get-AzureRmAutomationModule @Params
            }
            catch [Microsoft.Azure.Commands.Automation.Common.ResourceNotFoundException] {
                Write-Verbose "Cannot find module '$($Module.Name)' in automation account '$AutomationAccountName'."
                $ExistingModule = $null
            }

            if ($null -eq $ExistingModule) {
                Write-Output "Adding new module: $($Module.Name) $($Module.Version)"
                $AutomationModule = New-AzureRmAutomationModule -ContentLink $ContentLink @Params
            }
            elseif ($ExistingModule.IsGlobal) {
                Write-Output "Updating global module $($Module.Name) $($ExistingModule.Version) --> $($Module.Version)"
                $AutomationModule = New-AzureRmAutomationModule -ContentLink $ContentLink @Params
            }
            elseif ($ExistingModule.Version -ne $Module.Version) {
                Write-Output "Changing existing module: $($Module.Name) $($ExistingModule.Version) --> $($Module.Version)"
                $AutomationModule = Set-AzureRmAutomationModule -ContentLinkUri $Module.Package -ContentLinkVersion $Module.Version @Params
            }
            else {
                Write-Output "Module up to date: $($Module.Name) $($Module.Version)"
            }

            if ($null -ne $AutomationModule) {
                $PollCount = 0
                # Wait by default (for dependency purposes). TODO: Add this to the module config
                while($PollCount -lt $MaxModulePoll -and 
                    $AutomationModule.ProvisioningState -ne 'Succeeded' -and
                    $AutomationModule.ProvisioningState -ne 'Failed') {
                        $PollCount++
                        Start-Sleep -Seconds 10
                        Write-Verbose "Polling for $($Module.Name) completion..."
                        $AutomationModule = $AutomationModule | Get-AzureRmAutomationModule
                }

                if ($PollCount -eq $MaxModulePoll -and 
                    $AutomationModule.ProvisioningState -ne 'Succeeded' -and
                    $AutomationModule.ProvisioningState -ne 'Failed') {
                    Write-Error -Message "Failed to upload module: $($Module.Name) - PollCount reached max limit."
                    continue
                }

                if ($AutomationModule.ProvisioningState -eq 'Failed') {
                    Write-Error -Message "Failed to upload module: $($Module.Name) - ProvisioningState Failed"
                    continue
                }
            }
            
            Write-Output "Completed upload of $($Module.Name)"
        }
    }
}

function Publish-AatAutomationPackage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false, DefaultParameterSetName = 'NamedPackages')]    
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AutomationAccountName,
        [Parameter(Mandatory = $false)]
        [Switch]$DeployRunbooks,    
        [Parameter(Mandatory = $false)]
        [Switch]$DeployModules,
        [Parameter(Mandatory = $false)]
        [Switch]$DeployVariables,
        [Parameter(Mandatory = $false)]
        [Switch]$DeployCredentials,
        [Parameter(Mandatory = $false)]
        [Switch]$NewCredentialsOnly,
        [Parameter(Mandatory = $false)]
        [int]$JsonAssetDepth = 4,
        [Parameter(Mandatory = $false)]
        [ValidatePattern('^.+\.ps1$')]
        [string]$RunbookFilter = '*.ps1',
        [Parameter(Mandatory = $false)]
        [ValidatePattern('^.+\.json$')]
        [string]$AssetsFileFilter = '*.json',
        [Parameter(Mandatory = $false, ParameterSetName = 'NamedPackages')]
        [ValidateNotNullOrEmpty()]
        [string[]]$PackageName,
        [Parameter(ParameterSetName = 'AllPackages')]
        [switch]$AllPackages
    )
    
    Write-Verbose -Message "Parameter set: $($PSCmdlet.ParameterSetName)"    

    if ($PSCmdlet.ParameterSetName -eq 'NamedPackages') {
        if (-not $PackageName) {
            $PackageName = Get-AatWorkingPackage
        }
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'AllPackages') {
        $PackageName = (Get-ChildItem -Path (Get-AatWorkingFolder) -Directory).Name
    } 
    else {
        throw "Unexpected parameter set: $($PSCmdlet.ParameterSetName)"
    }

    Write-Verbose -Message "Parameters:"

    $PSBoundParameters.GetEnumerator() | ForEach-Object {
        Write-Verbose -Message "$($_.Key): $($_.Value)"
    }
    
    $DeployAssets = $DeployVariables -or $DeployCredentials 

    if (-not ($DeployRunbooks.IsPresent -or $DeployModules.IsPresent -or $DeployAssets)) {
        Write-Warning -Message "Nothing to deploy, please specify -DeployRunbooks, -DeployModules, -DeployVariables, or -DeployCredentials"
    }
    elseif ($PSCmdlet.ShouldProcess("$ResourceGroupName/$AutomationAccountName", 'Publish automation packages')) {                        
        $Paths = $PackageName | ForEach-Object {
            $Path = Join-Path -Path (Get-AatWorkingFolder) -ChildPath $_ -Resolve
            Write-Verbose -Message "Will publish package: $_  ($Path)"
            $Path
        }  

        $Paths | ForEach-Object {
            Write-Verbose -Message "Searching '$_'"

            if ($DeployRunbooks) {
                Write-Output "INFO: Deploying runbooks from '$_'."
                DeployRunbooks -Path $_ -Filter $RunbookFilter
                Write-Output "INFO: Deploying runbooks from '$_' - done."
            }

            if ($DeployModules) {
                Write-Output "INFO: Deploying modules from '$_'."
                DeployModules -Path $_
                Write-Output "INFO: Deploying modules from '$_'- done."
            }

            if ($DeployAssets) {
                Write-Output "INFO: Deploying assets from '$_'."
                DeployAssets -Path $_ -Filter $AssetsFileFilter
                Write-Output "INFO: Deploying assets from '$_' - done."
            }

            $CommonParameters = @{ResourceGroupName = $ResourceGroupName; AutomationAccountName = $AutomationAccountName}
            $VariableName = '~LastDeploymentTime'
            $Value = (Get-Date).ToUniversalTime().ToString('s') + 'Z'
            $Params = @{Name = $VariableName}
            $Params += $CommonParameters
            $Variable = (Get-AzureRmAutomationVariable @Params -ErrorAction 'Ignore')
            $Params += @{Encrypted = $false; Value = $Value}

            if (!$Variable) {
                New-AzureRmAutomationVariable @Params
            }
            else {
                Set-AzureRmAutomationVariable @Params
            }            
            
            Write-Verbose -Message "Searching '$_' - done."
        }
    }
}

function GetModuleBlob {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType([hashtable[]])]
    param (
        [Parameter(Mandatory = $true,
                    ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Version,

        # @{Name=<Name>; Version=<Version>; Package=<Package>;}
        [Parameter(Mandatory = $true,
                    ParameterSetName = 'ByModuleList')]
        [hashtable[]]
        $ModuleList,

        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(ParameterSetName = 'ByModuleList')]
        [switch]
        $IgnoreDependencies,

        [Parameter()]
        [System.Collections.Generic.List[hashtable]]
        $FinalList
    )

    begin {
        if ($null -eq $FinalList) {
            Write-Verbose "Creating FinalList"
            $FinalList = [System.Collections.Generic.List[hashtable]]::new()
        }

        if ($PsCmdlet.ParameterSetName -eq 'ByName') {
            $ModuleList += @{Name = $Name}
            if (-not [string]::IsNullOrWhiteSpace($Version)) {
                $ModuleList[0]['Version'] = $Version
            }
        }
    }

    process {
        foreach ($ModuleEntry in $ModuleList) {
            $InfoSplat = @{Name = $ModuleEntry.Name}
            if ($ModuleEntry['Version'] -and
                -not [string]::IsNullOrWhiteSpace($ModuleEntry.Version)) {
                $InfoSplat['Version'] = $ModuleEntry.Version
            }
            $Info = GetModuleInfo @infoSplat
            if (-not $Info) {
                continue
            }

            $Name = $info.title.'#text'
            $Version = $info.properties.version

            if (-not $version) {
                throw "Cannot resolve version of module '$Name'. Please check module name!"
                continue
            }
            
            if ($FinalList.Where({$_.Name -eq $name -and $_.Version -eq $Version})) {
                Write-Verbose "Module '$Name' is already in the FullList. Skipping addition"
            }
            else {
                Write-Verbose "Adding '$Name' to FullList"
                Write-Verbose "Resolving URL..."


                $ModuleContentUrl = "https://www.powershellgallery.com/api/v2/package/$Name/$version"
                do {
                    $ModuleContentUrl = (Invoke-WebRequest -Uri $ModuleContentUrl -MaximumRedirection 0 -UseBasicParsing -ErrorAction Ignore).Headers.Location 
                } while(!$ModuleContentUrl.Contains(".nupkg"))
                
                $Entry = @{
                    Name = $Name
                    Version = $Version
                    Package = $ModuleContentUrl
                }
                Write-Verbose -Message "Inserting into FinalList: @{Name=$Name; Version=$Version; Package=$ModuleContentUrl}"
                $FinalList.Insert(0, $Entry)
            }

            if (-not $IgnoreDependencies.IsPresent) {
                $Dependencies = $info.properties.Dependencies

                if($Dependencies -and $dependencies.Length -gt 0) {
                    $Dependencies = $dependencies.Split("|")
                
                    $DependencyNames = @()
                    foreach ($Dependency in $Dependencies) {
                        if (-not $Dependency -and $Dependency.Length -gt 0) {
                            continue
                        }

                        $split = $Dependency.Split(':')
                        $DependencyName = $split[0]
                        $DependencyVersion = $split[1] -replace '\[', '' -replace '\]', ''

                        if (-not $DependencyName) {
                            Write-Verbose 'Dependency has no name. Skipping.'
                            continue
                        }
                    
                        $CurrentEntry = $FinalList | Where-Object -FilterScript {
                            $_.Name -eq $DependencyName -and $_.Version -eq $DependencyVersion
                        }

                        if ($CurrentEntry) {
                            Write-Verbose "Entry $DependencyName[$dependencyVersion] already exists in the list. Skipping"
                            # Push the entry above this module to make sure dependencies are installed first
                            # Out-Null to stop the boolean entering pipeline and PowerShell casting to an object[] (that was fun to debug!)
                            $FinalList.Remove($CurrentEntry) | Out-Null 
                            $FinalList.Insert(0, $CurrentEntry)
                            continue
                        }

                        $FinalList = GetModuleBlob -ModuleList @{Name=$dependencyName; Version=$dependencyVersion} -FinalList $FinalList
                    }
                }
            }   
        }

        $FinalList
    }
}

function GetModuleInfo
{
    [CmdletBinding()]
    param (
        # Name of the module
        [Parameter(Mandatory = $true,
                    ValueFromPipelineByPropertyName = $true)]
        [Alias('ModuleName')]
        [string]
        $Name,

        # Version of the module
        [Parameter(Mandatory = $false)]
        [Alias('ModuleVersion')]
        [string]
        $Version
    )

    Write-Verbose "Gathering information about module '$Name' : '$Version'"

    if ([string]::IsNullOrWhiteSpace($Version)) {
        $Url = "https://www.powershellgallery.com/api/v2/Search()?`$filter=IsLatestVersion&searchTerm=%27$Name%27&targetFramework=%27%27&includePrerelease=false&`$skip=0&"

        $Filter = {
            $_.title.'#text' -eq $Name
        }
    }
    else {
        $Url = "https://www.powershellgallery.com/api/v2/Search()?searchTerm=%27$Name%27&targetFramework=%27%27&includePrerelease=false&`$skip=0&"
        $Filter = {
            $_.title.'#text' -eq $Name -and
            $_.Properties.Version -eq $Version
        }
    }

    Write-Verbose "Querying url: '$Url'"
    $SearchResult = Invoke-RestMethod -Method Get -Uri $Url -UseBasicParsing

    if($SearchResult -is [Array] -and $SearchResult.Count -and $SearchResult.Count -gt 1) {
        $SearchResult = $SearchResult | Where-Object -FilterScript $Filter
    }

    if(-not $SearchResult) {
        throw "Could not find module '$Name':'$Version' on PowerShell Gallery. This may be a module you imported from a different location"
    }
    else {
        $ModuleName = $SearchResult.title.'#text' # get correct casing for the module name
        # Output to pipeline
        Invoke-RestMethod -Method Get -UseBasicParsing -Uri $SearchResult.id | Select -ExpandProperty entry
    }
}
