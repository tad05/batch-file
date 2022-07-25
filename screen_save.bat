@echo off
ECHO *기준
ECHO.
ECHO 양호 : 화면 보호기 사용, 대기 시간 10분, 암호 설정
ECHO 취약 : 화면 보호기 미사용, 대기시간 미설정, 암호 미설정
ECHO.
ECHO *현황
ECHO.
reg query "HKEY_CURRENT_USER\Control Panel\Desktop">NUL
IF NOT ERRORLEVEL 1 reg query "HKEY_CURRENT_USER\Control Panel\Desktop">screen_save.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaveActive">screen_result.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaverlsSecure">>screen_result.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaveTimeOut">>screen_result.txt

ECHO.
ECHO *결과
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaveActive"') DO (
	IF %%A NEQ 1 (
		ECHO 화면 미설정
		GOTO Active_settings
	)ELSE (
		ECHO 화면 설정
		GOTO L2
	)
)
:Active_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f > NUL
ECHO 화면설정 완료

:L2
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaverlsSecure"') DO (
	IF %%A NEQ 1 (
		ECHO 암호 미설정
		GOTO Secure_settings
	)ELSE (
		ECHO 암호 설정
		GOTO L3
	)
)
:Secure_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverlsSecure /t REG_SZ /d 1 /f>NUL
ECHO 암호설정 완료

:L3
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaveTimeOut"') DO (
	IF %%A NEQ 600 (
		ECHO 대기 시간 60분으로 미설정
		GOTO TimeOut_settings
	)ELSE (
		ECHO 대기 시간 60분으로 설정
		GOTO END
	)
)
:TimeOut_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f
ECHO 대기 시간 설정 완료

:END 
ECHO.
ECHO 점검완료




