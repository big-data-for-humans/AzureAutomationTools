
$ErrorActionPreference = 'Stop'

$OutputFolder = 'out\PackageManagement'
$SourceFolder = 'src\PackageManagement'
$DocsFolder = 'docs\PackageManagement'  

if(Test-Path -Path $OutputFolder -PathType Any){
    Remove-Item -Path $OutputFolder -Recurse
}

New-Item -Path $OutputFolder -ItemType Container
Copy-Item -Path $SourceFolder\* -Destination $OutputFolder -Recurse
Import-Module (Resolve-Path $OutputFolder\AzureAutomationTools.PackageManagement.psd1)
New-ExternalHelp -Path $DocsFolder -OutputPath "$OutputFolder\en-US"

