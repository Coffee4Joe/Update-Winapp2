@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

echo.CD=%CD%
pushd %~dp0
echo.CD=%CD%
echo Checking For Updates!
findstr " Version:" winapp2.ini > oldversion.txt
powershell -command $web=New-Object Net.WebClient ; $web.DownloadString('https://raw.githubusercontent.com/MoscaDotTo/Winapp2/master/Winapp2.ini') | find " Version:" > version.txt

fc oldversion.txt version.txt /lb1 /w > nul
if errorlevel 1 goto :update

:next
echo No New Updates!
del oldversion.txt version.txt

CHOICE /C YN /M "Would You Like To Update Anyways?:" 
IF ERRORLEVEL 2 goto :no
IF ERRORLEVEL 1 GOTO :update

:no
pause
exit

:update
echo Update Is Available!
echo Would You Like to Update? (ctrl+c to cancel)
del oldversion.txt version.txt
pause 
del winapp2-old.ini
ren winapp2.ini winapp2-old.ini
powershell Invoke-WebRequest https://raw.githubusercontent.com/MoscaDotTo/Winapp2/master/Winapp2.ini -OutFile winapp2.ini 
echo winapp2.ini Has Been Updated!
pause
