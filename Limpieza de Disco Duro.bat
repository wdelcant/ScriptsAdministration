@echo ************************************************
@echo *******                                 ********
@echo *******       Limpieza de Disco         ********
@echo *******            EA 1603              ********
@echo *******                                 ******** 
@echo ************************************************
@echo Limpia Temporales y Log del PC local
@echo off

c:
cd\
cd .\Windows\Temp\
del /s/a/q/f *.log
del /s/a/q/f *.tmp
del /s/a/q/f *.msp
cls
echo Listo: Archivos LOGs y TMPs eliminados.


