@echo off
ECHO *����
ECHO.
ECHO ��ȣ : ���� ������Ʈ�� ���� ��� ����
ECHO ��� : ���� ������Ʈ�� ���� ���
ECHO.
ECHO *��Ȳ
ECHO.
net start
IF NOT ERRORLEVEL 1 net start > net_start.txt
ECHO ���
ECHO.
TYPE net_start.txt | FINDSTR /C:"Remote Registry" > NUL
IF NOT ERRORLEVEL 1 (
		ECHO ���� ������Ʈ�� ���񽺸� ����ϰ� �ֽ��ϴ�.
		GOTO STOP
)ELSE (
		ECHO ���� ������Ʈ�� ���񽺸� ������� �ʰ� �ֽ��ϴ�.
		GOTO END
)
:STOP
NET STOP "Remote Registry"> NUL
ECHO ���� ������Ʈ�� ���� ���� �Ϸ�

:END 
ECHO.
ECHO ���˿Ϸ�