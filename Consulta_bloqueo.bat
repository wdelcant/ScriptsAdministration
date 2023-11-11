@echo off
echo.
echo Hola!, este es un consultor de cuentas 2023 - Cencosud S.A.
echo.
ECHO Ingrese el nombre de usuario de dominio :
:INPUT

SET /P INPUT=%=%

net user %INPUT% /domain
pause /
