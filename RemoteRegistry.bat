@echo off
ECHO *기준
ECHO.
ECHO 양호 : 원격 레지스트리 서비스 사용 중지
ECHO 취약 : 원격 레지스트리 서비스 사용
ECHO.
ECHO *현황
ECHO.
net start
IF NOT ERRORLEVEL 1 net start > net_start.txt
ECHO 결과
ECHO.
TYPE net_start.txt | FINDSTR /C:"Remote Registry" > NUL
IF NOT ERRORLEVEL 1 (
		ECHO 원격 레지스트리 서비스를 사용하고 있습니다.
		GOTO STOP
)ELSE (
		ECHO 원격 레지스트리 서비스를 사용하지 않고 있습니다.
		GOTO END
)
:STOP
NET STOP "Remote Registry"> NUL
ECHO 원격 레지스트리 서비스 중지 완료

:END 
ECHO.
ECHO 점검완료