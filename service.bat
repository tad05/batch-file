@echo off

echo.
echo [IIS, FTP 서비스 구동 점검]
echo.
echo.
echo * IIS 서비스 구동 점검 *
echo -판단 기준-
echo 양호: IIS 서비스가 필요하지 않아 사용하지 않는 경우
echo 취약: IIS 서비스가 필요하지 않지만 사용하는 경우
echo 	[결과]
net start | find/I "world wide web"
echo.
echo.
echo * FTP 서비스 동작 확인"
echo -판단 기준-
echo 양호: FTP 서비스를 이용하지 않는 경우 또는 secure FTP를 사용하는 경우
echo 취약: FTP 서비스를 사용하는 경우
echo.
echo 	[결과]
net start | find/I "ftp"
echo.
echo.
echo ========================