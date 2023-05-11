# PS-iPerf
Module for check network performance, example for measure the communication channel inside an IPSec/GRE tunnel. Creating metrics for output to console PSObject and log file.

## iPerf-Server
```
PS C:\Users\support4> iPerf-Server -Start
PS C:\Users\support4> iPerf-Server -Status | fl

Server  : vproxy-04
Status  : Running
Port    : 5201
RunTime : 00:00:03

PS C:\Users\support4> iPerf-Server -Stop
PS C:\Users\support4> iPerf-Server -Status | fl

Server  : vproxy-04
Status  : Stopped
Port    :
RunTime :
```
## iPerf-Client
```
PS C:\Users\support4> $SpeedTest = iPerf-Client 192.168.1.55 -MBytes 1000 -LogWrite
PS C:\Users\support4> $SpeedTest

Client          : 192.168.5.2:50956
Server          : 192.168.1.55:5201
Protocol        : TCP
Streams         : 1
Start_Time      : 5/10/2023 5:38:04 PM
Run_Time        : 58 sec
Transfer_MBytes : 1000
Upload_MBits    : 138.26
Download_MBits  : 138.24
Intervals       : {@{Start_Seconds=0; End_Seconds=5; Run_Seconds=5.01; Transfer_MBytes=83.5; Speed_MBits=133.30},
                  @{Start_Seconds=5; End_Seconds=10; Run_Seconds=4.99; Transfer_MBytes=94; Speed_MBits=150.72},
                  @{Start_Seconds=10; End_Seconds=15; Run_Seconds=5.01; Transfer_MBytes=89.125; Speed_MBits=142.24},
                  @{Start_Seconds=15; End_Seconds=20; Run_Seconds=4.99; Transfer_MBytes=86.5; Speed_MBits=138.67}...}

PS C:\Users\support4> $SpeedTest.Intervals | ft

Start_Seconds End_Seconds Run_Seconds Transfer_MBytes Speed_MBits
------------- ----------- ----------- --------------- -----------
            0           5 5.01                   83.5 133.30
            5          10 4.99                     94 150.72
           10          15 5.01                 89.125 142.24
           15          20 4.99                   86.5 138.67
           20          25 5.00                 94.375 151.07
           25          30 5.00                     82 131.21
           30          35 5.00                 86.375 138.14
           35          40 5.00                 86.375 138.26
           40          45 5.00                 77.875 124.55
           45          50 5.00                  85.75 137.18
           50          55 5.00                   86.5 138.49
           55          58 2.86                 47.625 133.20
```

## Log
```
PS C:\Users\support4> iPerf-Client -LogRead

Date       Time     Download     Upload
----       ----     --------     ------
05/10/2023 16:48:47 125.95 MBits 126.00 MBits
05/10/2023 16:50:35 126.84 MBits 126.88 MBits
05/10/2023 16:59:57 75.57 MBits  75.59 MBits
05/10/2023 17:02:20 130.11 MBits 130.15 MBits
05/10/2023 17:09:10 141.29 MBits 141.34 MBits
05/10/2023 17:09:53 80.29 MBits  80.32 MBits
05/10/2023 17:17:34 144.44 MBits 144.57 MBits
05/10/2023 17:18:55 140.51 MBits 140.63 MBits
05/10/2023 17:23:00 139.82 MBits 139.84 MBits
05/10/2023 17:26:40 141.11 MBits 141.13 MBits
05/10/2023 17:38:04 138.24 MBits 138.26 MBits
```

![Image alt](https://github.com/Lifailon/PS-iPerf/blob/rsa/Screen/iperf-logfile.jpg)

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
