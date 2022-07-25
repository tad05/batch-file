@echo off
ECHO *기준
ECHO.
ECHO 양호 : 이벤트 로그 파일 용량 및 보관 기간 설정 적용
ECHO 취약 : 이벤트 로그 파일 용량 및 보관 기간 설정 미적용
ECHO.
ECHO *현황
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /t REG_DWORD
IF NOT ERRORLEVEL 1 reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /t REG_DWORD > log_save.txt
ECHO.
ECHO *결과
FOR /F "tokens=3" %%A IN ('TYPE log_save.txt ^| FINDSTR -L "MaxSize"') DO (
	IF %%A NEQ 10240 (
		ECHO 최대 로그 크기 미설정
		GOTO Active_settings
	)ELSE (
		ECHO 최대 로그 크기 설정
		GOTO L2
	)
)
:Active_settings
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /v MaxSize /t REG_DWORD /d 10240 /f > NUL
ECHO 최대 로그 크기 설정 완료

:L2
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE log_save.txt ^| FINDSTR -L "Retention"') DO (
	IF %%A NEQ 7776000 (
		ECHO 90일 이후 이벤트 덮어쓰기 미설정
		GOTO Secure_settings
	)ELSE (
		ECHO 90일 이후 이벤트 덮어쓰기 설정
		GOTO END
	)
)
:Secure_settings
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /v Retention /t REG_DWORD /d 7776000 /f > NUL
ECHO 90일 이후 이벤트 덮어쓰기 설정 완료


:END 
ECHO.
ECHO 점검완료