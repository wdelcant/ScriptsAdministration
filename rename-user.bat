@echo off

rem Solicita el nombre de la cuenta de usuario
set /p accountName="Ingrese el nombre de la cuenta de usuario: "

rem Obtiene el nombre de la carpeta de usuario
set "folderName=C:\Users\%accountName%"

rem Renombra la carpeta de usuario
rename "%folderName%" "%accountName%.old"

rem Busca y elimina la entrada en ProfileList que coincida con la carpeta de usuario antigua
for /f "delims=" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" ^| find "ProfileImagePath"^| find /i "%accountName%"') do (
    set "regEntry=%%a"
    setlocal enabledelayedexpansion
    rem Elimina la entrada del registro encontrada
    reg delete "!regEntry!" /f
    endlocal
)

rem Imprime un mensaje de éxito
echo La carpeta de usuario "%accountName%" ha sido renombrada a "%accountName%.old".
echo La entrada en el registro del ProfileList para "%accountName%" ha sido eliminada.

rem Mantiene la consola abierta
pause
