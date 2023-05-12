<#
Module for check network performance, example for measure the communication channel inside an IPSec/GRE tunnel.
Creating metrics for output to console PSObject and log file.
The measurement is used to iperf3 (version 3.1.3)

Cmdlet:
Connect-iPerfServer
Get-iPerfLog
Start-iPerfServer
Get-iPerfServer
Stop-iPerfServer
Test-iPerfToTelegram

Source:
https://github.com/Lifailon/PS-iPerf
https://github.com/esnet/iperf
https://iperf.fr/iperf-download.php
#>

function Start-iPerfServer {
    param (
        [string]$Port = 5201
    )
    $ModulePath = (Get-Module PS-iPerf).ModuleBase
    $iperf = "$ModulePath\iperf\iperf3.exe"
    .$iperf -s -D -p $Port
}

function Get-iPerfServer {
    param (
        [string]$Port = 5201
    )
    $Proc_iperf = Get-Process | Where-Object Name -match iperf
    if ($Proc_iperf -ne $null) {
        $Status_Out  = "Running"
        $Proc_Out = $Proc_iperf | 
        Select-Object @{Name="ProcessorTime"; Expression={$_.TotalProcessorTime -replace "\.\d+$"}},
        @{Name="Memory"; Expression={[string]([int]($_.WS / 1024kb))+"MB"}},
        @{Label="RunTime"; Expression={((Get-Date) - $_.StartTime) -replace "\.\d+$"}}
        $server_port = (Get-NetTCPConnection -OwningProcess $Proc_iperf.id).LocalPort
    } else {
        $Status_Out  = "Stopped"
    }
    $Collections = New-Object System.Collections.Generic.List[System.Object]
    $Collections.Add([PSCustomObject]@{
        Server      = hostname;
        Status      = $Status_Out;
        Port        = $server_port;
        RunTime     = $Proc_Out.RunTime
    })
    $Collections
}

function Stop-iPerfServer {
    Get-Process | Where-Object Name -match iperf | Stop-Process
}

function Connect-iPerfServer {
    param (
        [string]$Server,
        [string]$Port = 5201,
        [string]$MBytes = 1100,
        [switch]$Download,
        [switch]$LogWrite,
        $LogPath = "$home\Documents\iperf-log.txt"
    )
    
    $TestPort = Test-NetConnection $Server -Port $Port -InformationLevel Quiet
    if ($TestPort -eq $true) {
        $ModulePath = (Get-Module PS-iPerf).ModuleBase
        $iperf = "$ModulePath\iperf\iperf3.exe"
        $Traffic = $MBytes+"MB"
    
        if ($Download) {
            $out_json = .$iperf -c $Server -p $port -n $Traffic -i 5 -J -R
        } else {
            $out_json = .$iperf -c $Server -p $port -n $Traffic -i 5 -J
        }
        $out = $out_json | ConvertFrom-Json
    
        $Intervals = $out.intervals.sum | 
        Select-Object @{Name="Start_Seconds"; Expression={[int]$_.start}},
        @{Name="End_Seconds"; Expression={[int]$_.End}},
        @{Name="Run_Seconds"; Expression={$_.Seconds.ToString("0.00")}},
        @{Name="Transfer_MBytes"; Expression={$_.bytes/1024/1024}},
        @{Name="Speed_MBits"; Expression={([int]$_.bits_per_second/1MB).ToString("0.00")}}
    
        $Sent     = $out.end.sum_sent     | Select-Object @{Name="Speed"; Expression={($_.bits_per_second/1MB).ToString("0.00")}}
        $Received = $out.end.sum_received | Select-Object @{Name="Speed"; Expression={($_.bits_per_second/1MB).ToString("0.00")}}
    
        $EpochTime = [DateTime]"1/1/1970"
        $TimeZone = Get-TimeZone
        $UTCTime = $EpochTime.AddSeconds($out.start.timestamp.timesecs)
        $Time = $UTCTime.AddMinutes($TimeZone.BaseUtcOffset.TotalMinutes)
    
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        $Collections.Add([PSCustomObject]@{
            Client          = $out.start.connected.local_host+":"+$out.start.connected.local_port;
            Server          = $out.start.connected.remote_host+":"+$out.start.connected.remote_port;
            Protocol        = $out.start.test_start.protocol;
            Streams         = $out.start.test_start.num_streams;
            Start_Time      = $Time;
            Run_Time        = [string]([int]$out.Intervals.Streams[-1].End)+" sec";
            Transfer_MBytes = $out.start.test_start.bytes/1024/1024;
            Upload_MBits    = $Sent.Speed;
            Download_MBits  = $Received.Speed;
            Intervals       = @($Intervals)
        })
        $Collections
    
        if ($LogWrite) {
            [string]$Download = $Collections.Download_MBits
            [string]$Upload   = $Collections.Upload_MBits
            $Out_Log = "$Time  Download: $Download MBits  Upload: $Upload MBits"
            $Out_Log | Out-File $LogPath -Encoding UTF8 -Append
        }
    }    
}

function Get-iPerfLog {
    param (
        $LogPath = "$home\Documents\iperf-log.txt"
    )
    $TestLog = Test-Path $LogPath
    if ($TestLog -eq $True) {
        $gcLog = Get-Content $LogPath
        $Collections = New-Object System.Collections.Generic.List[System.Object]
        foreach ($gcl in $gcLog) {
            $out = $gcl -split "\s\s"
            $dt  = $out[0] -split "\s"
            $Collections.Add([PSCustomObject]@{
                Date        = $dt[0];
                Time        = $dt[1];
                Download    = $out[1] -replace "Download: ";
                Upload      = $out[2] -replace "Upload: ";
            })
        }
    }
    $Collections
}

function Test-iPerfToTelegram {
    param (
    [string]$Server,
    [string]$Port = 5201,
    [string]$MBytes = 1100,
    [string]$Trigger = 150,
    [string]$Token_Bot, # "5517149522:AAFop4_darMpTT7VgLpY2hjkDkkV1dzmGNM"
    [string]$Id_Chat    # "-609779646"
    )
    
    function Send-Telegram ($out) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $payload = @{
            "chat_id" = $Id_Chat
            "text" = $out
            "parse_mode" = "html"
        }
        Invoke-RestMethod -Uri (
            "https://api.telegram.org/bot{0}/sendMessage" -f $Token_Bot
        ) -Method Post -ContentType "application/json;charset=utf-8" -Body (ConvertTo-Json -Compress -InputObject $payload)
    }

    $int_upload     = Connect-iPerfServer -Server $Server -Port $Port -MBytes $MBytes -LogWrite
    $int_download   = Connect-iPerfServer -Server $Server -Port $Port -MBytes $MBytes -LogWrite -Download

    $up   = $int_upload.Upload_MBits.Replace(",",".")
    $down = $int_download.Download_MBits.Replace(",",".")

    if ([int]$up -lt $Trigger) {
        Send-Telegram "Low network channel upload speed: <b>$up MBits</b>"
    }

    if ([int]$down -lt $Trigger) {
        Send-Telegram "Low network channel download speed: <b>$down MBits</b>"
    }
}