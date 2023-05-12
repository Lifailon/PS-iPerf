# PS-iPerf
Module for check network performance, example for measure the communication channel inside an IPSec/GRE tunnel. Creating metrics for output to console PSObject and log file. \
The measurement is used to [iperf3](https://github.com/esnet/iperf) [(version 3.1.3)](https://iperf.fr/iperf-download.php)
## Install
Copy directory **PS-iPerf** to one of the dectories: `$env:PSModulePath.Split(";")`

Example: \
`Copy-Item -Path .\PS-iPerf "$home\Documents\WindowsPowerShell\Modules\" -Recurse`
## Cmdlet
```
PS C:\Users\support4> Import-Module PS-iPerf
PS C:\Users\support4> (Get-Module PS-iPerf).ExportedCommands.Keys

Connect-iPerfServer
Get-iPerfLog
Get-iPerfServer
Start-iPerfServer
Stop-iPerfServer
Test-iPerfToTelegram
```
## Server
```
PS C:\Users\support4> Start-iPerfServer
PS C:\Users\support4> Get-iPerfServer | fl

Server  : vproxy-04
Status  : Running
Port    : 5201
RunTime : 00:00:05

PS C:\Users\support4> Stop-iPerfServer
PS C:\Users\support4> Get-iPerfServer | fl

Server  : vproxy-04
Status  : Stopped
Port    :
RunTime :
```

## Client
```
PS C:\Users\support4> $SpeedTest = Connect-iPerfServer -Server 192.168.11.55 -MBytes 500 -LogWrite
PS C:\Users\support4> $SpeedTest

Client          : 192.168.5.2:59272
Server          : 192.168.1.55:5201
Protocol        : TCP
Streams         : 1
Start_Time      : 5/12/2023 11:33:07 AM
Run_Time        : 29 sec
Transfer_MBytes : 500
Upload_MBits    : 135.64
Download_MBits  : 135.60
Intervals       : {@{Start_Seconds=0; End_Seconds=5; Run_Seconds=5.00; Transfer_MBytes=81.875; Speed_MBits=130.98},
                  @{Start_Seconds=5; End_Seconds=10; Run_Seconds=5.00; Transfer_MBytes=81.375; Speed_MBits=130.12},
                  @{Start_Seconds=10; End_Seconds=15; Run_Seconds=5.00; Transfer_MBytes=86.375; Speed_MBits=138.19},
                  @{Start_Seconds=15; End_Seconds=20; Run_Seconds=5.00; Transfer_MBytes=87.5; Speed_MBits=140.04}...}

PS C:\Users\support4> $SpeedTest.Intervals | ft

Start_Seconds End_Seconds Run_Seconds Transfer_MBytes Speed_MBits
------------- ----------- ----------- --------------- -----------
            0           5 5.00                 81.875 130.98
            5          10 5.00                 81.375 130.12
           10          15 5.00                 86.375 138.19
           15          20 5.00                   87.5 140.04
           20          25 5.00                  85.75 137.07
           25          29 4.48                 77.125 137.65
```
## Log
![Image alt](https://github.com/Lifailon/PS-iPerf/blob/rsa/Screen/iPerf-Log.jpg)

```
PS C:\Users\support4> Get-iPerfLog

Date       Time     Download     Upload
----       ----     --------     ------
05/12/2023 11:16:32 117.84 MBits 117.87 MBits
05/12/2023 11:17:48 129.06 MBits 129.10 MBits
05/12/2023 11:21:04 137.52 MBits 137.55 MBits
05/12/2023 11:32:00 137.88 MBits 137.93 MBits
05/12/2023 11:33:07 135.60 MBits 135.64 MBits
```

## Test iPerf to Telegram
Sending alert to Telegram if the trigger (key: **-Trigger**) value is lower than the specified value in MBits.

```
PS C:\Users\support4> Test-iPerfToTelegram -Server 192.168.1.55 -MBytes 500 -Trigger 150 -Token_Bot 5517149522:AAFop4_d
arMpTT7VgLpY2hjkDkkV1dzmGNM -Id_Chat -609779646

  ok result
  -- ------
True @{message_id=377336; from=; chat=; date=1683881278; text=Low network channel upload speed: 126.18 MBits; entiti...
True @{message_id=377337; from=; chat=; date=1683881279; text=Low network channel download speed: 141.95 MBits; enti...
```

> Set parameters for Token_Bot, Id_Chat (line 148-149) and add command to the **Task Scheduler**.

![Image alt](https://github.com/Lifailon/PS-iPerf/blob/rsa/Screen/iPerf-Alert.jpg)
