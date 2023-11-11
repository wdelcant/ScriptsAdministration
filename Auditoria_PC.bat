@ECHO OFF
color 0a
SETLOCAL EnableDelayedExpansion
ECHO Auditoria de equipos Cencosud v1.0
ECHO -----------------------------------
ECHO INGRESA LA SUCURSAL DEL EQUIPO (Ej: N001)
ECHO -----------------------------------
ECHO SUCURSAL:
:INPUT 

SET /P INPUT=%=%

REM Crear carpeta auditoria si no existe
IF NOT EXIST "Auditoria" (
    MKDIR "Auditoria"
)

REM Crear carpeta del local si no existe
IF NOT EXIST "Auditoria\%INPUT%" (
    MKDIR "Auditoria\%INPUT%"
)

REM Formatear la fecha
SET FECHA=%DATE:~0,2%_%DATE:~3,2%_%DATE:~6,4%

ECHO -----------------------------------
ECHO DATOS DEL EQUIPO
ECHO -----------------------------------
FOR /F "usebackq" %%i IN (`hostname`) DO SET "NOMBRE=%%i"
ECHO NOMBRE DE EQUIPO: !NOMBRE!
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic computersystem get domain /VALUE`) DO SET "domain=%%i"
IF "!domain!"==("WORKGROUP") (
    ECHO ESTA EN DOMINIO: NO
) ELSE (
    ECHO ESTA EN DOMINIO: SI
)
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic CSPRODUCT GET VENDOR /VALUE`) DO SET "vendor=%%i"
ECHO MARCA: !vendor!
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic CSPRODUCT GET VERSION /VALUE`) DO SET "modelo=%%i"
ECHO MODELO: !modelo!
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic bios get serialnumber /VALUE`) DO SET "serial=%%i"
ECHO NUMERO DE SERIE: %serial%
ECHO.
ECHO -----------------------------------
ECHO DATOS RED:
ECHO -----------------------------------
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic nicconfig where "IPEnabled='True' and DHCPEnabled='True' " get DHCPEnabled /VALUE`) DO SET "dhcp=%%i"
IF "!dhcp!"=="TRUE" (
    ECHO DHCP HABILITADO: SI
) ELSE (
    ECHO DHCP HABILITADO: NO
)
FOR /F "usebackq tokens=2 delims=:" %%i IN (`ipconfig^|FINDSTR "IPv4"`) DO SET "ip=%%i"
ECHO DIRECCION IP: !ip!
FOR /F "usebackq tokens=2 delims=:" %%i IN (`ipconfig^|FINDSTR "Máscara subred"`) DO SET "mask=%%i"
ECHO MASCARA DE SUBRED: !mask!
FOR /F "usebackq tokens=2 delims=:" %%i IN (`ipconfig^|FINDSTR "Puerta enLace"`) DO SET "gateway=%%i"
ECHO PUERTA DE ENLACE: !gateway!
FOR /F "usebackq tokens=2 delims==" %%i IN (`wmic nic where "NetEnabled='true' and PhysicalAdapter='true'" get MACAddress /VALUE`) DO SET "mac=%%i"
ECHO DIRECCION MAC: !mac!
ECHO.
ECHO -----------------------------------
ECHO DATOS MONITOR:
ECHO -----------------------------------
REM Ejecutar dxdiag y guardar la salida en un archivo temporal
dxdiag /t dxdiag.txt
REM Filtrar el archivo dxdiag.txt y guardar los datos en variables
FOR /F "tokens=1,* delims=:" %%a IN ('FINDSTR /C:"Monitor Name" /C:"Monitor Model" /C:"Monitor Id" dxdiag.txt') DO (
    SET "property=%%a"
    SET "value=%%b"
    REM Si la variable property es igual a Monitor Name, entonces guardar el valor en la variable monitor
    IF "!property!"=="Monitor Name" (
        SET "monitor=!value!"
    )
    REM Si la variable property es igual a Monitor Model, entonces guardar el valor en la variable model
    IF "!property!"=="Monitor Model" (
        SET "model=!value!"
    )
    REM Si la variable property es igual a Monitor Id, entonces guardar el valor en la variable serial
    IF "!property!"=="Monitor Id" (
        SET "serial=!value!"
    )
    ECHO !property!: !value! 
)
ECHO.
REM Crear un archivo de texto con los datos del equipo
ECHO -----------------------------------
ECHO GUARDANDO DATOS EN EL ARCHIVO...
ECHO -----------------------------------
 (
    ECHO -----------------------------------
    ECHO DATOS DEL EQUIPO:
    ECHO -----------------------------------
    ECHO NOMBRE DE EQUIPO: !NOMBRE!
    ECHO ESTA EN DOMINIO: !domain!
    ECHO MARCA: !vendor!
    ECHO MODELO: !modelo!
    ECHO NUMERO DE SERIE: %serial%
    ECHO.
    ECHO -----------------------------------
    ECHO DATOS DEL RED:
    ECHO -----------------------------------
    ECHO DHCP HABILITADO: !dhcp!
    ECHO DIRECCION IP: !ip!
    ECHO MASCARA DE SUBRED: !mask!
    ECHO PUERTA DE ENLACE: !gateway!
    ECHO DIRECCION MAC: !mac!
    ECHO.
    ECHO -----------------------------------
    ECHO DATOS DE MONITOR: 
    ECHO -----------------------------------
    FOR /F "tokens=1,* delims=:" %%a IN ('FINDSTR /C:"Monitor Name" /C:"Monitor Model" /C:"Monitor Id" dxdiag.txt') DO (
    SET "property=%%a"
    SET "value=%%b"
    ECHO !property!: !value! 
)
) > "Auditoria\%INPUT%\%serial%.txt"

REM Eliminar el archivo temporal dxdiag.txt
DEL dxdiag.txt
ECHO.
ECHO -----------------------------------
ECHO LOS DATOS SE HAN GUARDADO EN EL ARCHIVO "%serial%-%FECHA%.txt"
ECHO -----------------------------------
PAUSE 