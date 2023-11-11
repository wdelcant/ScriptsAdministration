@echo off

rem Obtener el nombre de usuario actual
set user=%username%

rem Preguntar si desea agregar otro usuario
echo Desea agregar otro usuario? (y/n)
set /p answer=

rem Si el usuario respondio "si", preguntar su nombre
if "%answer%"=="y" (
    echo Cual es el nombre del usuario?
    set /p otheruser=
)

rem Obtener una lista de carpetas que no se deben borrar
set exceptions=administrador, _licen, Public, Default, wmdelcan, All Users, Default User

rem Recorrer las carpetas en C:\Users
for /f "delims=" %%f in ('dir /b c:\users') do (

    rem Verificar si la carpeta esta en la lista de excepciones
    if not "%exceptions:" %%f= "==" (

        rem Verificar si la carpeta es el usuario actual
        if "%%%f"=="%user%" (
            continue
        )

        rem Verificar si la carpeta es el otro usuario
        if "%answer%"=="y" && "%%f"=="%otheruser%" (
            continue
        )

        rem Eliminar la carpeta
        del /f /s /q "%%f"
    )
)

rem Terminado
echo Terminado.