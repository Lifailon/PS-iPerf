# PS-iPerf
Module for test network channel performance

```
PS C:\Users\support4> $SpeedTest = iPerf-Client 192.168.11.55 -MBytes 1000 -LogWrite
PS C:\Users\support4> $SpeedTest

Client          : 192.168.55.2:50872
Server          : 192.168.11.55:5201
Protocol        : TCP
Streams         : 1
Start_Time      : 5/10/2023 5:26:40 PM
Run_Time        : 57 sec
Transfer_MBytes : 1000
Upload_MBits    : 141.13
Download_MBits  : 141.11
Intervals       : {@{Start_Seconds=0; End_Seconds=5; Run_Seconds=5.00; MBytes=89.375; MBits=142.93},
                  @{Start_Seconds=5; End_Seconds=10; Run_Seconds=5.00; MBytes=87.375; MBits=139.78},
                  @{Start_Seconds=10; End_Seconds=15; Run_Seconds=5.00; MBytes=81.5; MBits=130.29},
                  @{Start_Seconds=15; End_Seconds=20; Run_Seconds=4.99; MBytes=90.75; MBits=145.37}...}

PS C:\Users\support4> $SpeedTest.Intervals | ft

Start_Seconds End_Seconds Run_Seconds MBytes MBits
------------- ----------- ----------- ------ -----
            0           5 5.00        89.375 142.93
            5          10 5.00        87.375 139.78
           10          15 5.00          81.5 130.29
           15          20 4.99         90.75 145.37
           20          25 5.00        93.375 149.31
           25          30 5.00        86.375 138.28
           30          35 5.00        87.125 139.37
           35          40 5.00        90.625 144.96
           40          45 5.00        89.625 143.49
           45          50 5.00        84.375 134.92
           50          55 5.00        89.125 142.66
           55          57 1.68        30.375 144.49
```
