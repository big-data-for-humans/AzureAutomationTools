
$ErrorActionPreference = 'Stop'

$OutputFolder = 'out\PackageManagement'
$SourceFolder = 'src\PackageManagement'
$DocsFolder = 'docs\PackageManagement'  

Import-Module -Name PSScriptAnalyzer

$Results = Invoke-ScriptAnalyzer -Path src\PackageManagement\AzureAutomationTools.PackageManagement.psm1 -Settings 'CodeFormatting'

if($Results.Count -ne 0){
    $Results 
    throw 'Failed CodeFormatting rules'
}

# excluding PSUseDeclaredVarsMoreThanAssignments as seems to false positive on += to arrays
$Results = Invoke-ScriptAnalyzer -Path src\PackageManagement\AzureAutomationTools.PackageManagement.psm1 -Settings 'PSGallery' -ExcludeRule 'PSUseDeclaredVarsMoreThanAssignments'

if($Results.Count -ne 0){
    $Results 
    throw 'Failed PSGallery rules'
}

if(Test-Path -Path $OutputFolder -PathType Any){
    Remove-Item -Path $OutputFolder -Recurse
}

New-Item -Path $OutputFolder -ItemType Container
Copy-Item -Path $SourceFolder\* -Destination $OutputFolder -Recurse
Import-Module (Resolve-Path $OutputFolder\AzureAutomationTools.PackageManagement.psd1)
New-ExternalHelp -Path $DocsFolder -OutputPath "$OutputFolder\en-US"

Write-Verbose -Message (Resolve-Path $OutputFolder) -Verbose
