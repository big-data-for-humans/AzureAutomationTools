Set-StrictMode -Version latest

function Export-AatAutomationRunbookLog {
    param (
        # Target ResourceGroupName of the AutomationAccount
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceGroupName,

        # Automation account to pull the logs from
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AutomationAccountName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $StorageAccountResourceGroupName = $ResourceGroupName,

        # Storage account name to post the logs to
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $StorageAccountName,
        
        # Storage container to post the logs to - best solution is to create a blank container called 'logs'
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $StorageContainerName,

        # Runbook names to include
        [Parameter()]
        [string[]]
        $IncludeRunbook = '*',

        # Runbook names to exclude
        [Parameter()]
        [string[]]
        $ExcludeRunbook = $null,

        # Collect logs completed after this datetime
        [Parameter()]
        [datetime]
        $CollectLogsFrom = [datetime]::MinValue,

        # Collect logs completed until this datetime
        [Parameter()]
        [datetime]
        $CollectLogsTo = [datetime]::MaxValue
    )

    $ErrorActionPreference = 'Stop'

    #region Helper functions

    function TestRunbookInclusion {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $RunbookName
        )
        $Result = $false

        foreach ($Inclusion in $IncludeRunbook) {
            if ($RunbookName -like $Inclusion) {
                $Result = $true
                break
            }
        }

        foreach ($Exclusion in $ExcludeRunbook) {
            if ($RunbookName -like $Exclusion) {
                $Result = $false
                break
            }
        }

        return $Result
    }

    #endregion

    #region pre-Azure checks

    if ($CollectLogsTo -lt $CollectLogsFrom) {
        throw "CollectLogsFrom cannot be greater than CollectLogsTo! CollectLogsFrom: $($CollectLogsFrom.ToString('s')); CollectLogsTo: $($CollectLogsTo.ToString('s'))"
    }

    if ($null -eq $IncludeRunbook) {
        $IncludeRunbook = '*'
    }

    #endregion

    $KeySplat = @{
        ResourceGroupName = $StorageAccountResourceGroupName
        Name = $StorageAccountName
    }
    $StorageAccountKeyObj = (Get-AzureRmStorageAccountKey @KeySplat)
    if ($StorageAccountKeyObj -is [System.Collections.IList]) {
        $StorageAccountKey = $StorageAccountKeyObj |
            Where-Object KeyName -eq 'Key1' |
            Select-Object -ExpandProperty 'Value'
    }
    else {
        $StorageAccountKey = $StorageAccountKeyObj.Key1
    }

    $ContextSplat = @{
        StorageAccountName = $StorageAccountName
        StorageAccountKey = $StorageAccountKey
    }
    $StorageContext = New-AzureStorageContext @ContextSplat
    $Container = Get-AzureStorageContainer -Name $StorageContainerName -Context $StorageContext


    Write-Output "Collecting jobs data..."
    $Jobs = Get-AzureRmAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName |
        Where-Object {
        $_.Status -In @('Completed', 'Failed', 'Stopped') -and 
        $_.EndTime.UtcDateTime -ge $CollectLogsFrom -and 
        $_.EndTime.UtcDateTime -le $CollectLogsTo -and 
        (TestRunbookInclusion -RunbookName $_.RunbookName)
    } | Get-AzureRmAutomationJob | Sort-Object -Property EndTime
            
    Write-Output "Collecting jobs data... Done."

    if ($Jobs.Count -eq 0) {
        Write-Output "Could not find any jobs."
        Write-Warning "Could not find any jobs."
        return
    }
    else {
        Write-Output "Logging $($Jobs.Count) jobs..."
    }

    # Check if job exists
    foreach ($Job in $Jobs) {
        Write-Verbose "Capturing:@{ Name = $($Job.RunbookName); Start = $($Job.CreationTime.UtcDateTime.ToString('s')) }"
        $JobName = $Job.RunbookName
        $CreateDate = $job.CreationTime.UtcDateTime
        $Year = $CreateDate.Year
        $Month = [string]::Format('{0:00}', $CreateDate.Month)
        $Day = [string]::Format('{0:00}', $CreateDate.Day)
        $JobBlobPath = "$ResourceGroupName/$AutomationAccountName/$JobName/$Year/$Month/$Day/$($Job.JobId).json"

        try {
            $CurrentEntry = Get-AzureStorageBlob -Blob $JobBlobPath -Container $StorageContainerName -Context $StorageContext
            throw "Blob '$($JobBlobPath)' already exists in '$($StorageAccountName)/$($StorageContainerName)'."
        }
        catch [Microsoft.WindowsAzure.Commands.Storage.Common.ResourceNotFoundException] {
            Write-Verbose "No entry found for Blob '$($JobBlobPath)'. Continuing with import."
        }
        
        $LogObjParams = [ordered]@{}
        foreach ($Param in ($Job | Get-Member | Where-Object MemberType -eq 'Property').Name) {
            $Value = $Job."$Param"
            $LogObjParams[$Param] = $Value
        }
        
        $Params = @{
            JobId = $Job.JobId
            ResourceGroupName = $ResourceGroupName
            AutomationAccountName = $AutomationAccountName
        }

        $Streams = [ordered]@{}
        foreach ($Stream in @('Output', 'Warning', 'Error')) {
            $StreamData = Get-AzureRmAutomationJobOutput @Params -Stream $Stream
            $StreamOutput = @()
            foreach ($Entry in $StreamData) {
                $RecordParams = @{
                    Id = $Entry.StreamRecordId
                    JobId = $Job.JobId
                    ResourceGroupName = $ResourceGroupName
                    AutomationAccountName = $AutomationAccountName
                }
                $Record = Get-AzureRmAutomationJobOutputRecord @RecordParams
                
                $StreamOutput += @{
                    StreamRecordId = $Record.StreamRecordId
                    Time = $Record.Time
                    Value = $Record.Value
                }

                Write-Verbose "Captured record $($Entry.StreamRecordId)."
            }
            $Streams[$Stream] = $StreamOutput
        }

        $LogObjParams['Streams'] = $Streams
        $LogPath = [System.IO.Path]::GetTempFileName()
        $LogObjParams | ConvertTo-Json -Depth 100 | Set-Content -Path $LogPath -Force

        Set-AzureStorageBlobContent -File $LogPath -Container $StorageContainerName -Blob $JobBlobPath -Context $StorageContext | Out-Null
        Write-Output "Successfully uploaded log: '$JobBlobPath'"
        Remove-Item -Path $LogPath -Force
    }


    Write-Output "Finished harvesting logs."
}
