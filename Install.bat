@echo off
color 17

echo.
echo ¡Hola!, este es un instalador de aplicaciones para los Kioscos de Paris 2023 - Cencosud S.A.
echo.
echo ------------------------------------------------
echo Primero debes ingresar la ruta de la unidad del disco de las aplicaciones, EJ:   E:
echo ------------------------------------------------
echo.
echo [Ctrl+C] = Cancelar
echo.
echo Ingrese la unidad :
:input


set /P INPUT=%=%
if "%INPUT%"=="" goto :input

copy /Y "%INPUT%\Kioscos-Paris\Manual de configuracion.pdf" "C:\Users\Administrador\Desktop" 

powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
echo Configuración de energia completa.


echo Eliminando directorios y archivos...
rd /S /Q "C:\Program Files (x86)\Teams Installer"
rd /S /Q "C:\Users\Administrador\AppData\Local\Microsoft\Teams"
rd /S /Q "C:\Users\Administrador\AppData\Local\Microsoft\TeamsMeetingAddin"
rd /S /Q "C:\Users\Administrador\AppData\Local\Microsoft\TeamsPresenceAddin"


echo Eliminando icono de Teams del escritorio...
del "C:\Users\Administrador\Desktop\Microsoft Teams.lnk"


echo Configurando teclado principal en Español (Español Latinoamérica)...
reg add "HKCU\Keyboard Layout\Preload" /v 1 /d 0000040A /f 
reg add "HKCU\Keyboard Layout\Substitutes" /v "00000409" /d "0000040A" /f 


:Menu
cls
echo Instalador de Kioscos Paris 2023 - Cencosud S.A.
echo Seleccione su opcion tecleando el numero respectivo.
echo.
echo 0. Java x64
echo 1. Java x86
echo 2. NCR-7197
echo 3. RSM-NCR
echo 4. RPS-Config
echo 5. Verifone PINPAD
echo 6. TotemParis Config
echo 7. Kiosco
echo 8. Configurar Archivos
echo 9. Subir a dominio Cencojoin
echo 10. Subir a dominio manualmente (opcional)
echo 11. Reinciar Kiosco
echo 12. Salir

echo.
set /p var=Ingrese Opcion: 
if %var%==0 goto :cero
if %var%==1 goto :uno
if %var%==2 goto :dos
if %var%==3 goto :tres
if %var%==4 goto :cuatro
if %var%==5 goto :cinco
if %var%==6 goto :seis
if %var%==7 goto :siete
if %var%==8 goto :ocho
if %var%==9 goto :nueve
if %var%==10 goto :diez
if %var%==11 goto :once
if %var%==12 goto :doce
if %var% GTR 3 echo Error
goto :Menu

:cero
color 17
cls
echo INSTALANDO JAVA x64
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\jre-8u131-windows-x64.exe" /s
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE JAVA x86!!
pause
goto :Menu


:uno
color 17
cls
echo INSTALANDO JAVA x86
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

xcopy "%INPUT%\Kioscos-Paris\apps\Java x86\Java" "C:\Program Files (x86)\Java" /E /I /Y
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE NCR-7197!!
echo.
pause
goto :Menu


:dos
color 17
cls
echo INSTALANDO NCR-7197
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\x64\NCR-7197x64.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE RSM-NCR!!
echo.
pause
goto :Menu


:tres
color 17
cls
echo INSTALANDO RSM-NCR
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\x64\Retail_Platform_Software_for_Windows_x64.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE RPS-Config!!
echo.
pause
goto :Menu


:cuatro
color 17
cls
echo INSTALANDO RPS-Config
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\x64\RPSWx64_Config.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE Verifone PINPAD!!
echo.
pause
goto :Menu


:cinco
color 17
cls
echo INSTALANDO Verifone PINPAD
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\VeriFone.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE TotemParis Config!!
echo.
pause
goto :Menu


:seis
color 17
cls
echo INSTALANDO TotemParis Config
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\x64\totemParis.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA INSTALACION DE Kiosco!!
echo.
pause
goto :Menu


:siete
color 17
cls
echo INSTALANDO Kiosco
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\kiosco-paris-setup.exe" /s
echo.
echo INSTALACION FINALIZADA, CONTINUA CON LA CONFIGURACION DEL Kiosco!!
echo.
pause
goto :Menu


:ocho
color 17
cls
echo CONFIGURANDO ARCHIVOS
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

copy /Y "%INPUT%\Kioscos-Paris\apps\totemParisCencosud.properties" "C:\MicroTec\TotemParis\config" 
copy /Y "%INPUT%\Kioscos-Paris\apps\pos.cfg" "C:\MicroTec\TotemParis\SwitchClient\config"  
copy /Y "%INPUT%\Kioscos-Paris\apps\kiosco-paris.lnk" "C:\Users\Administrador\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"  
echo Configurando Totem Paris
notepad "C:\MicroTec\TotemParis\config\totemParisCencosud.properties"
echo Configurando Pinpad
notepad "C:\MicroTec\TotemParis\SwitchClient\config\pos.cfg"


echo.
echo CONFIGURACION FINALIZADA, AHORA SUBELO A DOMINIO Y MUEVELO DE OU!!
echo.
pause
goto :Menu


:nueve
color 17
cls
echo SUBIR KIOSCO A DOMINIO CENCOJOIN
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

"%INPUT%\Kioscos-Paris\apps\CencoJoinv4.exe" /s

echo.
echo INSTALACION FINALIZADA!!
echo.
pause
goto :Menu


:diez
color 17
cls
echo SUBIR KIOSCO A DOMINIO MANUALMENTE
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

sysdm.cpl

echo.
echo SUBIDO CORRECTAMENTE!!
echo.
pause
goto :Menu


:once
color 17
cls
echo REINCIAR
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

shutdown /r /t 0

echo.
echo REINICIANDO...
echo.
pause
goto :Menu


:doce
color 17
cls
echo SALIR
echo ------------------------------------------------
echo [Ctrl+C] = Cancelar

exit

echo.
echo SALIENDO DEL INSTALADOR
echo.
pause
goto :Menu
```



