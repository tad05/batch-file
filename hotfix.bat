@echo off
set YEAR=%date:~0,4%
set MONTH=%date:~5,2%
ECHO *����
ECHO.
ECHO ��ȣ : �ֽ� Hot Fix ����
ECHO ��� : �ֽ� Hot Fix ������
ECHO.
ECHO *��Ȳ
ECHO.
wmic qfe get HotFixID,Description,InstalledOn > NUL
IF NOT ERRORLEVEL 1 wmic qfe get HotFixID,Description,InstalledOn
ECHO.
ECHO *���
ECHO.
wmic qfe get InstalledOn > hotfix.txt
TYPE hotfix.txt | FINDSTR -L "%YEAR%" > hotfix_result.txt
setlocal EnableDelayedExpansion
	IF NOT ERRORLEVEL 1 ( 
		For /F "tokens=1,2,3 delims=/" %%A in (hotfix_result.txt) DO (
			set /a MONTH=%MONTH%-%%A
			IF !MONTH! LEQ 6 (
				GOTO :RESULT
			)
		)
	)
set /a YEAR=%YEAR%-1
TYPE hotfix.txt | FINDSTR -L "%YEAR%" > hotfix_result.txt
	IF NOT ERRORLEVEL 1 (
		For /F "tokens=1,2,3 delims=/" %%A in (hotfix_result.txt) DO (
			set /a MONTH=%%A-%MONTH%
			IF !MONTH! GEQ 6 ( 
				GOTO :RESULT
			)
		)
	)
GOTO :BRESULT

:BRESULT
ECHO ��� / �ֱ� 6������ Hot Fix ��ġ ������ �����ϴ�.
ECHO Hot Fix �ֽ� ������ Ȯ���� �ּ���.
GOTO :End 

:RESULT
ECHO ��ȣ /  �ֱ� 6�����̳��� Hot Fix ��ġ ������ �����մϴ�.

:End
ECHO ���� �Ϸ�