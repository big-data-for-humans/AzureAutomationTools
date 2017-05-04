
$ErrorActionPreference = 'Stop'

$Namespace = 'AzureAutomation'
$Packages = @(
    @{
        SourceFolder = 'src\PackageManagement'
        DocsFolder = "docs\PackageManagement"
    },
    @{
        SourceFolder = 'src\Logging'
        DocsFolder = 'docs\Logging'
    }
) 

Import-Module -Name PSScriptAnalyzer


foreach ($Package in $Packages) {
    $SourceFolder = $Package.SourceFolder
    $SourceFolderLiteral = Join-Path -Path $PSScriptRoot -ChildPath $SourceFolder
    $DocsFolder = $Package.DocsFolder
    $DocsFolderLiteral = Join-Path -Path $PSScriptRoot -ChildPath $DocsFolder

    if (-not (Test-Path -Path $SourceFolderLiteral)) {
        throw "Cannot find package src path: '$SourceFolderLiteral'. Please edit packages in build script!"
    }

    $Psd1Path = Get-ChildItem -Path $SourceFolderLiteral -Filter '*.psd1'
    if ($null -eq $Psd1Path) {
        throw "Cannot find psd1 file in package location: '$SourceFolderLiteral'"
    }
    if ($Psd1Path.count -gt 1) {
        throw "Multiple .psd1 files found in path '$SourceFolderLiteral'."
    }

    if ($Package.Keys -notcontains 'OutputFolder') {
        $OutputFolder = Join-Path -Path 'out' -ChildPath $Psd1Path.BaseName
    }
    else {
        $OutputFolder = $Package.OutputFolder
    }

    $Psd1Obj = Import-LocalizedData -BaseDirectory $Psd1Path.Directory -FileName $Psd1Path.Name
    $Psm1Path = Join-Path -Path $SourceFolderLiteral -ChildPath $Psd1Obj.RootModule
    $Results = Invoke-ScriptAnalyzer -Path $Psm1Path -Settings 'CodeFormatting'

    if($Results.Count -ne 0){
        $Results 
        Write-Warning "The file '$Psm1Path' Failed CodeFormatting rules. This PR will not be accepted in its current state!"
    }

    if(Test-Path -Path $OutputFolder -PathType Any){
        Remove-Item -Path $OutputFolder -Recurse
    }
    New-Item -Path $OutputFolder -ItemType Container

    Copy-Item -Path $SourceFolder\* -Destination $OutputFolder -Recurse

    # Test the import on a new PowerShell session
    $Ps = [scriptblock]::Create("Import-Module -Name $($Psd1Path.FullName)").GetPowerShell()
    $Ps.Invoke()

    if ($Ps.HadErrors) {
        $Exception = [Exception]::new("Failed to import module '$($Psd1Path.FullName)'. Reason: $($Ps.Streams.Error[0].Exception.Message)", $Ps.Streams.Error[0].Exception)
        throw $Exception
    }

    if ($null -eq $DocsFolder) {
        Write-Warning -Message "Package '$($Package.SourceFolder)' does not contain a DocsFolder parameter. This PR will not be accepted in its current state!"
    }
    elseif (-not (Test-Path -Path $DocsFolderLiteral)) {
        Write-Warning -Message "Package '$($Package.SourceFolder)' contains a DocsFolder parameter but the path '$DocsFolderLiteral' does not exist! This PR will not be accepted in its current state!"
    }
    else {
        New-ExternalHelp -Path $DocsFolderLiteral -OutputPath "$OutputFolder\en-US"
    }
    
    Write-Verbose -Message (Resolve-Path $OutputFolder) -Verbose
}
