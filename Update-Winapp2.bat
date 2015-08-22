@echo off
echo Checking For Updates!
findstr " Version:" "%ProgramFiles%"\CCleaner\winapp2.ini > "%ProgramFiles%"\CCleaner\oldversion.txt
powershell -command $web=New-Object Net.WebClient ; $web.DownloadString('http://www.winapp2.com/winapp2.ini') | find " Version:" > "%ProgramFiles%"\CCleaner\version.txt

fc "%ProgramFiles%"\CCleaner\oldversion.txt "%ProgramFiles%"\CCleaner\version.txt /lb1 /w > nul
if errorlevel 1 goto :error

:next
echo No New Updates!
del "%ProgramFiles%"\CCleaner\oldversion.txt "%ProgramFiles%"\CCleaner\version.txt
pause
exit

:error
echo Update Is Available!
echo Would You Like to Update? (ctrl+c to cancel)
del "%ProgramFiles%"\CCleaner\oldversion.txt "%ProgramFiles%"\CCleaner\version.txt
pause 
del "%ProgramFiles%"\CCleaner\winapp2-old.ini
ren "%ProgramFiles%\CCleaner\WINAPP2.INI" winapp2-old.ini
powershell Invoke-WebRequest http://winapp2.com/winapp2.ini -OutFile winapp2.ini 
move winapp2.ini "%ProgramFiles%"\CCleaner\
echo Winapp2.ini Has Been Updated!
pause
