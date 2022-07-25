@echo off

echo.
echo [SNMP 서비스 구동 점검]
echo -판단 기준-
echo 양호: SNMP 서비스를 사용하지 않는 경우
echo 취약: SNMP 서비스를 사용하는 경우
echo.
echo * SNMP 서비스 동작 확인 *
echo 	[결과]
net start | find/I "SNMP"
echo.
echo [SNMP 서비스 커뮤니티 스트링 적절성 점검]
echo -판단 기준-
echo 양호: SNMP를 사용하지 않고 있거나 Community String이 public, private이 아닌 경우
echo 취약: SNMP를 사용하며, Community String이 public, private인 경우
echo.
echo * SNMP String Name 확인 *
echo 	[결과]
reg query ""HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities"
echo. => Community String 추출
echo.
echo ==========================================================
