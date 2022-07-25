@ECHO OFF

ECHO - 기준 - 
ECHO 양호 : "계정 잠금 기간" 및 "잠금 기간 원래대로 설정 기간"이 설정되어 있는 경우
ECHO 취약 : "계정 잠금 기간" 및 "잠금 기간 원래대로 설정 기간"이 설정되어 있지 않은 경우

ECHO.
ECHO - 현황 -
net accounts |findstr /I /C:"잠금 기간"
net accounts |findstr /I /C:"잠금 관찰 창"

ECHO.
ECHO - 결과 -
net accounts |findstr /I /C:"잠금 기간" > LockTime.txt
FOR /f "tokens=1-6" %%a IN (LockTime.txt) DO SET LockTime=%%d

net accounts |findstr /I /C:"잠금 관찰 창" > LockReTime.txt
FOR /f "tokens=1-6" %%a IN (LockReTime.txt) DO SET LockReTime=%%e

IF %LockTime% GEQ 60 IF %LockReTime% GEQ 60 GOTO Lock-Y

:Lock-N
ECHO 취약
GOTO Lock-END

:Lock-Y
ECHO 양호
GOTO Lock-END

:Lock-END
DEL LockTime.txt
DEL LockReTime.txt