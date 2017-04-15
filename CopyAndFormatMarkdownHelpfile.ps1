
param (
    [string]$SourceFilePath,
    [string]$DestinationFilePath,
    [switch]$FindTopLevelHeader,
    [switch]$SkipEmptySecondLevelSections
)

class Node{    
    [int] $Level
    [string] $Name
    [string[]] $BodyText
    [System.Collections.Generic.List[Node]] $ChildNodes

    Node (){
        $this.ChildNodes = New-Object -TypeName 'System.Collections.Generic.List[Node]'
    }

    [string] Text (){
        return '#' * $this.Level.ToString() + ' ' + $this.Name
    }

    [bool] HasNonEmptyBodyText() {
        $NonBlankLines = ($this.BodyText | ? {$_ -ne ''}).Count

        return $NonBlankLines -ne 0
    }

    [bool] HasChildren() {
        return $this.ChildNodes.Count -ne 0
    }


    [string] ToString(){
        [string[]]$ret = @($this.Text())

        if($this.BodyText.Count -eq 0 -or $this.BodyText[0] -notmatch '^\s*$'){
            $ret += ''
        }
                
        $InFencedCodeBlock = $false

        foreach($Line in $this.BodyText){                   
            if(-not $InFencedCodeBlock){ 
                $InFencedCodeBlock = $Line.StartsWith('```')

                if($InFencedCodeBlock -and $Line.Trim() -eq '```'){
                    $Line = '```Powershell'
                }
            } 
            else {
                $InFencedCodeBlock =  -not $Line.StartsWith('```')            
            }

            $ret += $line            
        }
        
        foreach($ChildNode in $this.ChildNodes){
            $ret +=  $ChildNode.ToString()
        } 
        
        return [string]::Join("`r", $ret)
    }
}

function GetLevel {
    param (
        [string]$Line
    )
    
    [int] $Level = 0 # body text

    if($line -match '^#[^#].*$'){
        $Level = 1
    }
    elseif($line -match '^##[^#].*$') {
        $Level = 2
    }
    elseif($line -match '^###[^#].*$') {
        $Level = 3
    }
    elseif($line -match '^####[^#].*$') {
        $Level = 4
    }

    $Level
}

function GetName {
    param (
        [string]$Line
    )
    
    $level = GetLevel($Line)

    if($level -eq 0){
        throw "Not a header"
    }

    $ret = $Line.Substring($level).Trim()
    
    $ret    
}

$Lines = (gc $SourceFilePath) 
$LineNumber = 0

if($FindTopLevelHeader.IsPresent){
    while ($Lines[$LineNumber] -notmatch '^#[^#].*$' -and $LineNumber -lt $Lines.Count)
    {
        $LineNumber++
    }

    if($LineNumber -eq $Lines.Count){
        throw "Top level header not found in $SourceFilePath"
    }
}

$Lines = $Lines | Select-Object -Skip $LineNumber

$Nodes = New-Object -TypeName 'System.Collections.Generic.List[Node]'

if($lines[0] -match '^#[^#]+$'){
    $Node = New-Object -TypeName Node -Property @{Level=1; Name=GetName($Lines[0])}     
    $Nodes.Add($Node)
}
else {
    throw "First blank line not header 1"
}

$LineNumber = 1
$CurrentLevel = -1
$PreviousLevel = 1

[System.Collections.Stack] $ParentStack = New-Object -TypeName 'System.Collections.Stack'

$ParentStack.Push($Nodes[0])

while ($LineNumber -lt $Lines.Count){
    $Line = $Lines[$LineNumber].TrimEnd()

    $CurrentLevel = GetLevel($line)
    
    if($CurrentLevel -eq 1){
        throw "Document contains a second top level header $Line"
    }

    if($CurrentLevel -eq 0) {
       ($ParentStack.Peek()).BodyText += $Line
    } 
    else {
        $Node = New-Object -TypeName Node -Property @{Level=$CurrentLevel; Name=GetName($Line)}     

        if ($CurrentLevel -eq $PreviousLevel) { # sibling        
            $ParentStack.Pop() | Out-Null
            ($ParentStack.Peek()).ChildNodes.Add($Node)
            $ParentStack.Push($Node)
        } elseif ($CurrentLevel -gt $PreviousLevel) { # child
            ($ParentStack.Peek()).ChildNodes.Add($Node)
            $ParentStack.Push($Node)
        } elseif ($CurrentLevel -lt $PreviousLevel) {         
            while ($ParentStack.Peek().Level -ge $CurrentLevel){
                $ParentStack.Pop() | Out-Null            
            }

            ($ParentStack.Peek()).ChildNodes.Add($Node)
            $ParentStack.Push($Node)
        } 
    
        $PreviousLevel = $CurrentLevel
    }    
        
    $LineNumber++
}

if($SkipEmptySecondLevelSections.IsPresent){
    $NodesToRemove = $Nodes[0].ChildNodes| Where-Object {-not $_.HasNonEmptyBodyText() -and -not $_.HasChildren()} 

    $NodesToRemove | % {
        $Nodes[0].ChildNodes.Remove($_) | Out-Null
    }
}

$Nodes[0].ToString() | Set-Content -Encoding UTF8 -Path $DestinationFilePath
