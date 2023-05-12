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

## iPerf-ReportToTelegram
Sending notifications to Telegram if the trigger (**-Trigger**) value is lower than the specified value in MBits.

```
PS C:\Users\support4> iPerf-ReportToTelegram -Server 192.168.1.55 -MBytes 500 -Trigger 150 -Token_Bot 5517149522:AAFop4
_darMpTT7VgLpY2hjkDkkV1dzmGNM -Id_Chat -609779646

  ok result
  -- ------
True @{message_id=377334; from=; chat=; date=1683787385; text=Low network channel upload speed: 138.73 MBits; entiti...
True @{message_id=377335; from=; chat=; date=1683787385; text=Low network channel download speed: 145.60 MBits; enti...
```

> Add command to the task scheduler.

![Image alt](https://github.com/Lifailon/PS-iPerf/blob/rsa/Screen/iperf-report.jpg)
