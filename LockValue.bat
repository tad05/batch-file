@ECHO OFF

ECHO - 기준 -
ECHO 양호 : 계정 잠금 임계 값이 5 이하의 값으로 설정되어 있는 경우
ECHO 취약 : 계정 잠금 임계 값이 6 이상의 값으로 설정되어 있는 경우

ECHO.
ECHO - 현황 -
net accounts |findstr /I /C:"잠금 임계값"

ECHO.
ECHO - 결과 -
net accounts |findstr /I /C:"잠금 임계값" > Lock-value.txt

FOR /f "tokens=1-3" %%a IN (Lock-value.txt) DO SET Lock-value=%%c

IF %Lock-value% LEQ 5 ECHO 양호
IF NOT %Lock-value% LEQ 5 ECHO 취약

DEL Lock-value.txt