@echo off
echo Checking For Updates!
findstr " Version:" winapp2.ini > oldversion.txt
powershell -command $web=New-Object Net.WebClient ; $web.DownloadString('http://www.winapp2.com/winapp2.ini') | find " Version:" > version.txt

fc oldversion.txt version.txt /lb1 /w > nul
if errorlevel 1 goto :error

:next
echo No New Updates!
del oldversion.txt version.txt
pause
exit

:error
echo Update Is Available!
echo Would You Like to Update? (ctrl+c to cancel)
del oldversion.txt version.txt
pause 
del winapp2-old.ini
ren winapp2.ini" winapp2-old.ini
powershell Invoke-WebRequest http://winapp2.com/winapp2.ini -OutFile winapp2.ini 
echo Winapp2.ini Has Been Updated!
pause
