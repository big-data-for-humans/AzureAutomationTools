$ErrorActionPreference = 'Stop'

function Invoke-SqlQuery {
    [CmdletBinding(DefaultParameterSetName = 'CommandTextSet')]  
    param (
        [Parameter(Mandatory = $true,
                    ParameterSetName = 'CommandTextSet')]
        [string]
        $CommandText,

        [Parameter(Mandatory = $true,
                    ParameterSetName = 'ScriptSet')]
        $Path,

        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'CommandTextSet')]
        [Parameter(ParameterSetName = 'ScriptSet')]
        [string]
        $ConnectionString,

        [Parameter(ParameterSetName = 'CommandTextSet')]
        [Parameter(ParameterSetName = 'ScriptSet')]
        [switch]
        $NonQuery
    )

    [System.Data.SqlClient.SqlConnection] $DatabaseConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection -ArgumentList $ConnectionString
	$DatabaseConnection.Open()
    $DatabaseCommand = New-Object System.Data.SqlClient.SqlCommand
    $DatabaseCommand.Connection = $DatabaseConnection

    if ($PSCmdlet.ParameterSetName -eq 'CommandTextSet') {
        $DatabaseCommand.CommandText = $CommandText
    }
    else {
        $DatabaseCommand.CommandText = Get-Content -Path $Path -Raw
    }

    try {
        if ($NonQuery.IsPresent) {
            $RowsAffected = $DatabaseCommand.ExecuteNonQuery()
            Write-Verbose -Message "($($RowsAffected) row(s) affected)"
        }
        else {
            [System.Data.DataTable]$Data = New-Object System.Data.Datatable
            [System.Data.SqlClient.SqlDataReader]$Reader = $DatabaseCommand.ExecuteReader()
            $Data.Load($Reader)
            $Data
        }
    }
    finally {
        Write-Verbose "Closing Database Connection."
        $DatabaseConnection.Close()
        $DatabaseConnection.Dispose()
    }
}

function Export-SqlData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Query')]
        [string]
        $CommandText,
        
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [string]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [int]
        $BatchSize = 50000,

        [Parameter(Mandatory = $false)]
        [int]
        $BlockSize = 4Mb,

        [Parameter(Mandatory = $false)]
        [string]
        $FieldTerminator = "`t",

        [Parameter(Mandatory = $false)]
        [string]
        $LineTerminator = "`r`n",

        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
        $Encoding = [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]::Default,

        [Parameter(Mandatory = $false)]
        [switch]
        $IncludeColumnHeaders
    )
    
    $EncodingConverter = New-Object Microsoft.PowerShell.Commands.FileSystemContentDynamicParametersBase
    $EncodingConverter.Encoding = $Encoding
    [System.Text.Encoding] $Private:OutputEncoding = $EncodingConverter.EncodingType

    Write-Verbose "Starting Export..."
    [System.IO.StreamWriter] $Stream = New-Object System.IO.StreamWriter -ArgumentList  $Path, $false, $Private:OutputEncoding
    try {
        [System.Text.StringBuilder] $Buffer = New-Object -TypeName System.Text.StringBuilder -ArgumentList $BlockSize
    
        [System.Data.SqlClient.SqlConnection] $DatabaseConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection -ArgumentList $ConnectionString
        $DatabaseConnection.Open()
        try {
            [System.Data.SqlClient.SqlCommand] $DatabaseCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand -ArgumentList $CommandText, $DatabaseConnection
            try {
                $DatabaseCommand.CommandTimeout = 0
                [System.Data.SqlClient.SqlDataReader] $DataReader = $DatabaseCommand.ExecuteReader()
                try {
                    if ($DataReader.HasRows) {
                        $ColumnCount = $DataReader.FieldCount
                        $RowCount = 0
                        if ($IncludeColumnHeaders) {
                            for ($i = 0; $i -lt $ColumnCount; $i++) {
                                if ($i -gt 0) {
                                    $null = $Buffer.Append($FieldTerminator)
                                }
                                $null = $Buffer.Append($DataReader.GetName($i))
                            }
                            $null = $Buffer.Append($LineTerminator)
                            $RowCount++
                        }
                        while ($DataReader.Read()) {
                            for ($i = 0; $i -lt $ColumnCount; $i++) {
                                if ($i -gt 0) {
                                    $null = $Buffer.Append($FieldTerminator)
                                }
                                if (-not $DataReader.IsDBNull($i)) {
                                    $null = $Buffer.Append($DataReader.GetValue($i).ToString())
                                }
                            }
                            $null = $Buffer.Append($LineTerminator)
                            $RowCount++
                            if (($RowCount % $BatchSize) -eq 0) {
                                $Stream.Write($Buffer.ToString())
                                $null = $Buffer.Clear()
                                Write-Verbose "$($RowCount) rows exported."
                            }
                        }
                        # Output the last block
                        if ($Buffer.Length -gt 0) {
                            $Stream.Write($Buffer.ToString())
                        }
                        Write-Verbose "$($RowCount) rows exported."
                    }
                } finally {
                    $DataReader.Dispose()
                }
            } finally {
                $DatabaseCommand.Dispose()
            }
        } finally {
            $DatabaseConnection.Close()
            $DatabaseConnection.Dispose()
        }
    } finally {
        $Stream.Flush()
        $Stream.Close()
    }
    [System.GC]::Collect()
}

function Import-SqlData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Table,

        [Parameter(Mandatory = $true)]
        [string]
        $DataFile,

        [Parameter(Mandatory = $true)]
        [string]
        $ConnectionString,

        [Parameter(Mandatory = $false)]
        [int]
        $BatchSize = 50000,

        [Parameter(Mandatory = $false)]
        [int]
        $BlockSize = 4kb,

        [Parameter(Mandatory = $false)]
        [string]
        $FieldTerminator = "`t",

        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
        $Encoding = [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]::Default,

        [Parameter(Mandatory = $false)]
        [switch]
        $SkipColumnHeaders        
    )
    
    $EncodingConverter = New-Object Microsoft.PowerShell.Commands.FileSystemContentDynamicParametersBase
    $EncodingConverter.Encoding = $Encoding
    [System.Text.Encoding] $Private:InputEncoding = $EncodingConverter.EncodingType

    Write-Verbose "Starting Import..."
    [System.Data.SqlClient.SqlConnection] $DatabaseConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection -ArgumentList $ConnectionString
    $DatabaseConnection.Open()
    try {
        [System.Data.SqlClient.SqlBulkCopy] $SqlBulkCopy = New-Object -TypeName System.Data.SqlClient.SqlBulkCopy -ArgumentList $DatabaseConnection, ([System.Data.SqlClient.SqlBulkCopyOptions]::TableLock), $null
        try {
            $SqlBulkCopy.BulkCopyTimeout = 0
            $SqlBulkCopy.BatchSize = $BatchSize
            $SqlBulkCopy.DestinationTableName = $Table

            [System.Data.DataTable] $DataTable = New-Object -TypeName System.Data.DataTable
            try {
                [System.Data.SqlClient.SqlDataAdapter] $DataAdapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter -ArgumentList "SELECT TOP 0 * FROM $($Table)", $DatabaseConnection
                try {
                    $DataAdapter.Fill($DataTable)
                } finally {
                    $DataAdapter.Dispose()
                }
                [System.IO.StreamReader] $StreamReader = New-Object -TypeName System.IO.StreamReader -ArgumentList $DataFile, $Private:InputEncoding, $true, $BlockSize
                try {
                    if ($SkipColumnHeaders) {
                        $Headers = $StreamReader.ReadLine()
                    }
                    $RowCount = 0
                    while ($null -ne ($Row = $StreamReader.ReadLine())) {
                        $StringValues = $Row.Split($FieldTerminator)
                        [object[]] $ObjectValues = New-Object -TypeName 'object[]' -ArgumentList $DataTable.Columns.Count
                        for ($i = 0; $i -lt $DataTable.Columns.Count; $i++) {
                            if ([string]::IsNullOrWhiteSpace($StringValues[$i]) -and $DataTable.Columns[$i].AllowDBNull) {
                                $ObjectValues[$i] = [System.DBNull]::Value
                            } else {
                                $ObjectValues[$i] = $StringValues[$i]
                            }
                        }
                        $null = $DataTable.Rows.Add($ObjectValues)
                        $RowCount++;
                        if (($RowCount % $BatchSize) -eq 0) {  
                            $SqlBulkCopy.WriteToServer($DataTable)  
                            Write-Verbose "$($RowCount) rows imported."
                            $DataTable.Clear()  
                        }  
                    }
                    if($datatable.Rows.Count -gt 0) { 
                        $SqlBulkCopy.WriteToServer($DataTable) 
                        $DataTable.Clear() 
                        Write-Verbose "$($RowCount) rows imported."
                    }
                } finally {
                    $StreamReader.Close()
                    $StreamReader.Dispose()
                }
  
                Write-Verbose "$RowCount rows imported."
                #Write-Verbose "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 

            } finally {
                $DataTable.Dispose()
            }
        } finally {
            $SqlBulkCopy.Dispose()
        }
    } finally {
        $DatabaseConnection.Close()
        $DatabaseConnection.Dispose()
    }
    [System.GC]::Collect()
}

<#
.SYNOPSIS
    Replaces SQLCMD mode variables in a query with values from the supplied hashtable of variables.
.DESCRIPTION
    Replaces SQLCMD mode variables in the form $(Variable) in
.EXAMPLE
    Format-SqlQuery -Path .\QueryWithVariables.sql -Variable @{"Table" = "MyTable"}
    Outputs the contents of the supplied file with any instances of "$(Table)" replaced with "MyTable"
.EXAMPLE
    Format-SqlQuery -Query "SELECT * FROM $(Table)" -Variable @{"Table" = "MyTable"}
    Outputs the contents of the supplied query string with any instances of "$(Table)" replaced with "MyTable"
#>
function Format-SqlQuery {
    [CmdletBinding(DefaultParameterSetName='Query')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName='File')]
        [string]
        $Path,
 
        [Parameter(Mandatory = $true, ParameterSetName='Query')]
        [string]
        $Query,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $Variable
    )
    
    if ($PsCmdlet.ParameterSetName -eq 'File') {
        $Private:SourceFilePath = Join-Path -Path $Script:WorkingFolder -ChildPath $Path
        $Query  = Get-Content -Path $Private:SourceFilePath -Raw
    }

    if ($Variable) {
        foreach ($Kvp in $Variable.GetEnumerator()) {
            $Query = $Query -replace "\`$\($($Kvp.Name)\)", $Kvp.Value
        }
    }
    
    $Query
}


function Get-ExpandedSqlQuery{
    [CmdletBinding()]
    [Alias('Replace-Setvars')]
    param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [string]
    $Sqlfile,

    [Parameter(Mandatory=$true)]
    [hashtable]$VariableValues

    )
    $Query = Get-Content -Path $SqlFile

    $i = 0

    while (($Line = $Query[$i]) -eq '') {
        $i++
    }

    if ($Line.Trim().StartsWith( '/*')) {
        do {
            $i++
            $Line = $Query[$i]
        }
        until( $Line.Trim().StartsWith( '*/'))

        $i++

    }


    while (($Line = $Query[$i]) -eq '') {
        $i++
    }

    $Rows = $Query.Count

    $Variables = while (($Line = $Query[$i]).StartsWith(':')) {
        $Line
        $i++
    }

    $Variables = $Variables | ForEach-Object {
        $_.Split(' ', 3)[1]
    }

    while (($Line = $Query[$i]) -eq '') {
        $i++
    }

    $Query = $Query[$i..($Query.Count - 1)]

    [string[]]$keys = ($VariableValues.Keys)

    #if (($Missing = Compare-Object -ReferenceObject $Variables -DifferenceObject $keys)) {
    #    throw "Supplied values does not include values for: $([string]::Join(',',$Missing.InputObject))"
    #}

    $Query = $Query | ForEach-Object {
        foreach ($Variable in $VariableValues.GetEnumerator()) {
            $_ = $_.Replace("`$`($($Variable.Key)`)", $Variable.Value)
        }
        $_
    }

    #$Query | Set-Content "$SqlFile.updated"
    return [string]::Join("`r`n",$Query)
}