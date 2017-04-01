$SourcePath = "$Env:USERPROFILE\source\repos\azure-automation-tools\docs\PackageManagement"
$DestinationPath = "$Env:USERPROFILE\source\repos\azure-automation-tools.wiki"

$Helpfiles = [ordered]@{
    'Add-AatPackageVariable'    = 'Add-a-variable-definition'
    'Get-AatPackageFolderPath'     = 'Get-a-package-folder-path' 
    'Get-AatPackageOption'         = 'Get-package-options'
    'Get-AatPackagePath'           = 'Get-package-path'
    'Get-AatWorkingFolder'         = 'Get-working-folder'
    'Get-AatWorkingPackage'        = 'Get-working-package'
    'New-AatAssetsFile'            = 'Create-a-new-assets-file'
    'New-AatAutomationPackage'     = 'Create-a-new-automation-pacakge'
    'New-AatPackageVariable'       = 'Create-a-new-variable'
    'Publish-AatAutomationPackage' = 'Publish-an-automation-package'
    'Set-AatPackageOption'         =  'Set-package-options'
    'Set-AatWorkingFolder'         =  'Set-working-folder'
    'Set-AatWorkingPackage'        =  'Set-working-package'
    'Test-AatAutomationPackage'    =  'Test-an-automation-package'
}


# copy latest files from the 
$Helpfiles.GetEnumerator() | % {
   cp -Path "$SourcePath\$($_.Key).md" -Destination "$DestinationPath\$($_.Value).md"
}

# skip the headers
$Helpfiles.GetEnumerator() | % {
     
   Write-verbose "$DestinationPath\$($_.Value)"

   $Input = (gc -path "$DestinationPath\$($_.Value).md") 
   

   Write-verbose "lines $($Input.Length)"

    $i = 0
    
    do {
        $Line = $Input[$i] 
        $i++ 
    }
    until ($Line -match '^# .+$' -or $i -eq $Input.Length)
    
    if($i -eq $Input.Length){
        Write-warning "header 1 not found in $($_.Value)"
        continue
        
    }
    $i-- # 

    Write-verbose "Header at row $i"


    $Input | select -skip $i | % {
        $Match = [regex]::Match($_, '\[(?<command>.+)\]\(\.\)')

        if($Match.Success){
            $Command = $Match.Groups['command'].Value
            $Helpfile = $Helpfiles[$Command]

            if(-not $Helpfile){
                Write-Warning "help file $command not found in lookup"
                $HelpFile = '.'
            }

            "[$($Command)]($($Helpfile))"
        } else{
            $_         
        }

    }  | Set-Content -Path "$DestinationPath\$($_.Value).md" -Encoding UTF8 
}

#
$Helpfiles.GetEnumerator() | % {
   "- [$($_.Key)]($($_.Value))"

} 
