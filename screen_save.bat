@echo off
ECHO *����
ECHO.
ECHO ��ȣ : ȭ�� ��ȣ�� ���, ��� �ð� 10��, ��ȣ ����
ECHO ��� : ȭ�� ��ȣ�� �̻��, ���ð� �̼���, ��ȣ �̼���
ECHO.
ECHO *��Ȳ
ECHO.
reg query "HKEY_CURRENT_USER\Control Panel\Desktop">NUL
IF NOT ERRORLEVEL 1 reg query "HKEY_CURRENT_USER\Control Panel\Desktop">screen_save.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaveActive">screen_result.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaverlsSecure">>screen_result.txt
TYPE screen_save.txt | FINDSTR -L "ScreenSaveTimeOut">>screen_result.txt

ECHO.
ECHO *���
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaveActive"') DO (
	IF %%A NEQ 1 (
		ECHO ȭ�� �̼���
		GOTO Active_settings
	)ELSE (
		ECHO ȭ�� ����
		GOTO L2
	)
)
:Active_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f > NUL
ECHO ȭ�鼳�� �Ϸ�

:L2
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaverlsSecure"') DO (
	IF %%A NEQ 1 (
		ECHO ��ȣ �̼���
		GOTO Secure_settings
	)ELSE (
		ECHO ��ȣ ����
		GOTO L3
	)
)
:Secure_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverlsSecure /t REG_SZ /d 1 /f>NUL
ECHO ��ȣ���� �Ϸ�

:L3
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE screen_result.txt ^| FINDSTR -L "ScreenSaveTimeOut"') DO (
	IF %%A NEQ 600 (
		ECHO ��� �ð� 60������ �̼���
		GOTO TimeOut_settings
	)ELSE (
		ECHO ��� �ð� 60������ ����
		GOTO END
	)
)
:TimeOut_settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f
ECHO ��� �ð� ���� �Ϸ�

:END 
ECHO.
ECHO ���˿Ϸ�




