$SourcePath = "$Env:USERPROFILE\source\repos\azure-automation-tools\docs\PackageManagement"
$DestinationPath = "$Env:USERPROFILE\source\repos\azure-automation-tools.wiki"

$PublishData =  Import-PowerShellDataFile -Path "$PSScriptRoot\publish.psd1"

$Helpfiles = $PublishData.FileMap


# copy & format latest files from the 
$Helpfiles.GetEnumerator() | % {
   
   $Params = @{
        SourceFilePath = "$SourcePath\$($_.Key).md"
        DestinationFilePath = "$DestinationPath\$($_.Value).md"
        FindTopLevelHeader = $true
        SkipEmptySecondLevelSections = $true    
    }

    & "$PSScriptRoot\CopyAndFormatMarkdownHelpFile.ps1" @params
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

$Toc = '<!--toc-start-->', ''

$Toc += ($Helpfiles.GetEnumerator() | % {
   "- [$($_.Key)]($($_.Value))"
}) | sort 

$Toc += '', '<!--toc-end-->'

$FoundToc = $false

(cat "$Env:USERPROFILE\source\repos\azure-automation-tools.wiki\Package-Management.md") | % {

    if(-not $FoundToc){
        $FoundToc  = $_ -eq '<!--toc-start-->'
    
        if($FoundToc){
            $Toc
        } else {
            $_
        }

    } else  {
        $FoundToc = $_ -ne '<!--toc-end-->'
    }
} | Set-Content -Encoding UTF8 -Path "$Env:USERPROFILE\source\repos\azure-automation-tools.wiki\Package-Management.md"

