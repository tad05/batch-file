@echo off
net start >net_list.txt

set Anti1="Windows Defender Antivirus Service"

TYPE net_list.txt | findstr -i %Anti1% >nul
if errorlevel 1 (echo there is no %Anti1%) else (echo there is %Anti1%)