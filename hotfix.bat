@echo off
set YEAR=%date:~0,4%
set MONTH=%date:~5,2%
ECHO *기준
ECHO.
ECHO 양호 : 최신 Hot Fix 적용
ECHO 취약 : 최신 Hot Fix 미적용
ECHO.
ECHO *현황
ECHO.
wmic qfe get HotFixID,Description,InstalledOn > NUL
IF NOT ERRORLEVEL 1 wmic qfe get HotFixID,Description,InstalledOn
ECHO.
ECHO *결과
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
ECHO 취약 / 최근 6개월간 Hot Fix 설치 내역이 없습니다.
ECHO Hot Fix 최신 버전을 확인해 주세요.
GOTO :End 

:RESULT
ECHO 양호 /  최근 6개월이내에 Hot Fix 설치 내역이 존재합니다.

:End
ECHO 진단 완료