@echo off
ECHO *����
ECHO.
ECHO ��ȣ : �̺�Ʈ �α� ���� �뷮 �� ���� �Ⱓ ���� ����
ECHO ��� : �̺�Ʈ �α� ���� �뷮 �� ���� �Ⱓ ���� ������
ECHO.
ECHO *��Ȳ
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /t REG_DWORD
IF NOT ERRORLEVEL 1 reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /t REG_DWORD > log_save.txt
ECHO.
ECHO *���
FOR /F "tokens=3" %%A IN ('TYPE log_save.txt ^| FINDSTR -L "MaxSize"') DO (
	IF %%A NEQ 10240 (
		ECHO �ִ� �α� ũ�� �̼���
		GOTO Active_settings
	)ELSE (
		ECHO �ִ� �α� ũ�� ����
		GOTO L2
	)
)
:Active_settings
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /v MaxSize /t REG_DWORD /d 10240 /f > NUL
ECHO �ִ� �α� ũ�� ���� �Ϸ�

:L2
ECHO.
FOR /F "tokens=3" %%A IN ('TYPE log_save.txt ^| FINDSTR -L "Retention"') DO (
	IF %%A NEQ 7776000 (
		ECHO 90�� ���� �̺�Ʈ ����� �̼���
		GOTO Secure_settings
	)ELSE (
		ECHO 90�� ���� �̺�Ʈ ����� ����
		GOTO END
	)
)
:Secure_settings
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application" /v Retention /t REG_DWORD /d 7776000 /f > NUL
ECHO 90�� ���� �̺�Ʈ ����� ���� �Ϸ�


:END 
ECHO.
ECHO ���˿Ϸ�