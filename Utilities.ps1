# Author: Wilson Del Canto
# Cencosud S.A
$version = "1.6 alpha" # Versión del script
$date = "2023-11-11" # Fecha del ultimo cambio

# Este script proporciona una interfaz para realizar operaciones remotas en equipos Windows.

# Definir tiempo de espera predeterminado para operaciones remotas (en segundos).
$TiempoEsperaPredeterminado = 60

# Obtener la ruta del directorio del script
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Construir la ruta del archivo de registro en el mismo directorio que el script
$LogFile = Join-Path $ScriptDirectory "Log.txt"

# Limpia la consola al inicio del script.
Clear-Host

# Manejo de errores
trap {
    Write-Host "Error: $_" -ForegroundColor Red
    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ERROR: $_"
    continue
}

# Inicio del bucle principal del programa.
do {    
    Clear-Host
    # Presenta información sobre la versión y la fecha.
    Write-Host "Bienvenido al programa de operaciones remotas Cencosud S.A." -ForegroundColor Blue
    Write-Host ("# Version: $($version), Date: $($date)`n`n") -ForegroundColor Green

    # Menú principal que permite seleccionar entre diferentes opciones.
    $OpcionPrincipal = Read-Host -Prompt "Que deseas hacer?`n`n1. Realizar operaciones en equipo remoto`n2. Consulta usuario dominio`n3. Update`n4. Salir`n`nSelecciona la opcion"
    Clear-Host
    # Switch para manejar las diferentes opciones del menú principal.
    switch ($OpcionPrincipal) { 
        
        1 {
            # Operaciones en el equipo remoto.
            $Nombrepc = $null
            $Usuario = $null
            $Password = $null

            # Bucle para asegurarse de que se ingresen el nombre del equipo, el nombre de usuario y la contraseña.
            do {
                Clear-Host

                # Validación de entrada de usuario, contraseña y nombre de equipo.
                while (-not $Nombrepc -or -not $Usuario -or -not $Password) {
                    Write-Host "Por favor, ingresa el nombre del equipo, el nombre de usuario y la clave.`n"
                    $Nombrepc = Read-Host "Ingresa el nombre del equipo"
                    $Usuario = Read-Host "Ingresa el nombre de usuario"
                    $Password = Read-Host "Ingresa la clave" -AsSecureString

                    # Convierte la contraseña segura en texto plano.
                    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
                }

                Clear-Host
                # Menú de operaciones remotas.
                $Opcion = Read-Host "Que accion deseas realizar?`n`n1. Obtener serie`n2. Reiniciar PC`n3. Apagar PC`n4. Obtener información del sistema operativo`n5. Listar procesos en ejecución`n6. Cerrar programa`n7. Desinstalar programa (falta probar)`n8. Consultar usuarios en PC`n9.  Configurar red (falta probar)`n10. Listar programas instalados`n11. Verificar actualizaciones (falta probar)`n12. Actualizar equipo (falta probar)`n13. Actualizar politicas (falta probar)`n13. Veritificar integridad sfc (falta probar)`n15. Listar impresoras`n16. Agregar impresora IP`n17. Activar Office 365`n18. Salir`n`nSelecciona la opcion"

                # Switch para manejar las diferentes operaciones remotas.
                switch ($Opcion) {
                    1 {
                        # Obtener el número de serie del equipo.
                        $InicioOperacion = [DateTime]::Now
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password bios get serialnumber
                    }
                    2 {
                        # Reiniciar el equipo remoto.
                        $InicioOperacion = [DateTime]::Now
                        Write-Host "Reiniciando el equipo remoto. Esto puede tomar un tiempo..."
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password process call create "shutdown /r /t $TiempoEsperaPredeterminado /f"
                    }
                    3 {
                        # Apagar el equipo remoto.
                        Write-Host "Apagando el equipo remoto. Esto puede tomar un tiempo..."
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password process call create "shutdown /s /t $TiempoEsperaPredeterminado /f"
                    }
                    4 {
                        # Obtener información del sistema del equipo remoto.
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password os get caption,version,serialnumber
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    5 {
                        # Listar procesos en ejecución en el equipo remoto.
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password process list brief
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    6 {
                        # Cerrar un programa específico en el equipo remoto.
                        $Programa = Read-Host "Ingresa el nombre del programa a cerrar"
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password process where "name like '%$Programa%'" call terminate
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    7 {
                        # Desinstalar un programa específico en el equipo remoto.
                        $Programa = Read-Host "Ingresa el nombre del programa a desinstalar"
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password product where "name like '%$Programa%'" call uninstall
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    8 {
                        # Consultar usuarios en el equipo remoto.
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password useraccount list brief
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    9 {
                        # Configuración de red en el equipo remoto.
                        $IpConfiguracion = Read-Host "Deseas configurar la red? (s/n)"
                        if ($IpConfiguracion -eq 's') {
                            $DescripcionNIC = Read-Host "Ingresa la descripción de la interfaz de red (Ejemplo: Ethernet)"
                            $NuevaIP = Read-Host "Ingresa la nueva dirección IP"
                            $NuevaMascara = Read-Host "Ingresa la nueva máscara de subred"
                            $NuevaPuertaEnlace = Read-Host "Ingresa la nueva puerta de enlace"
                    
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password nicconfig where "description='$DescripcionNIC'" call enablestatic "$NuevaIP", "$NuevaMascara"
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password nicconfig where "description='$DescripcionNIC'" call setgateways "$NuevaPuertaEnlace" 1
                    
                            Write-Host "Configuracion de red aplicada con exito." -ForegroundColor Green
                        } else {
                            Write-Host "Operacion de configuracion de red cancelada."  -ForegroundColor Red
                        }
                    }
                    10 {
                        # Listar programas instalados en el equipo remoto.
                        
                        wmic /node:$Nombrepc /user:$Usuario /password:$Password product get name,version
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    11 {
                        # Verificar actualizaciones en el equipo remoto.
                        
                        Write-Host "Verificando actualizaciones en el equipo remoto..."
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            $updateSession = New-Object -ComObject Microsoft.Update.Session
                            $updateSearcher = $updateSession.CreateUpdateSearcher()
                            $updates = $updateSearcher.Search("IsInstalled=0")
                            $updates.Count
                        } -Credential (Get-Credential -UserName $Usuario)
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    12 {
                        # Aplicar actualizaciones en el equipo remoto.
                        
                        Write-Host "Aplicando actualizaciones en el equipo remoto..."
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            $updateSession = New-Object -ComObject Microsoft.Update.Session
                            $updateInstaller = $updateSession.CreateUpdateInstaller()
                            $updateInstaller.Updates = $updates
                            $installationResult = $updateInstaller.Install()
                            $installationResult.ResultCode
                        } -Credential (Get-Credential -UserName $Usuario)
                        Write-Host "Actualizaciones aplicadas con éxito." -ForegroundColor Green
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    } 
                    13 {
                        # Actualizar políticas de seguridad en el equipo remoto.

                        Write-Host "Actualizando políticas de seguridad en el equipo remoto..."
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            gpupdate /force /Sync
                        } -Credential (Get-Credential -UserName $Usuario)
                        Write-Host "Políticas de seguridad actualizadas con éxito." -ForegroundColor Green
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    14 {
                        # Verificar integridad del sistema en el equipo remoto.

                        Write-Host "Verificando la integridad del sistema en el equipo remoto..."
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            sfc /scannow
                        } -Credential (Get-Credential -UserName $Usuario)
                        Write-Host "Verificación de integridad del sistema completada con éxito." -ForegroundColor Green
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    } 
                    15 {
                        # Listar impresoras instaladas en el equipo remoto.

                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            Get-Printer
                        } -Credential (Get-Credential -UserName $Usuario)
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    16 {
                        # Agregar una cola de impresión por IP en el equipo remoto.

                        $NombreCola = Read-Host "Ingresa un nombre para la cola de impresión"
                        $DireccionIP = Read-Host "Ingresa la dirección IP de la impresora"
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock {
                            param($printerName, $ipAddress)
                            $port = [System.Net.Dns]::GetHostAddresses($ipAddress)
                            Add-PrinterPort -Name $port -PrinterHostAddress $ipAddress
                            Add-Printer -Name $printerName -PortName $port
                        } -ArgumentList $NombreCola, $DireccionIP -Credential (Get-Credential -UserName $Usuario)
                        Write-Host "Cola de impresión por IP agregada con éxito." -ForegroundColor Green
                        $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                    }
                    17 {
                        # Activar Office 365 de forma remota.
                        $InicioOperacion = [DateTime]::Now
                        Write-Host "Activando Office 365 de forma remota..."
                    
                        # Comandos para activar Office 365
                        $ScriptBlock = {
                            gpupdate /force /Sync
                            Enable-ScheduledTask -TaskPath '\Microsoft\Windows\Workplace Join' -TaskName Automatic-Device-Join
                            Start-ScheduledTask -TaskPath '\Microsoft\Windows\Workplace Join' -TaskName Automatic-Device-Join
                            dsregcmd /Debug /join
                        }
                    
                        # Ejecutar los comandos de activación de Office 365 en el equipo remoto.
                        Invoke-Command -ComputerName $Nombrepc -ScriptBlock $ScriptBlock -Credential (Get-Credential -UserName $Usuario)
                    
                        Write-Host "Office 365 activado con éxito de forma remota." -ForegroundColor Green
                        $Respuesta = Read-Host "¿Quieres volver al menú principal? (s/n)"
                    }                                        
                    18 {
                        # Opción para salir del bucle interno.
                        Exit-PSHostProcess
                    }
                    default {
                        Write-Host "Opcion invalida, favor verifique"  -ForegroundColor Red
                    }
                }

                # Registro de actividad
                Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Operación: $Opcion en $Nombrepc por $Usuario - Duración: $([DateTime]::Now - $InicioOperacion)"
                
                # Pregunta al usuario si desea realizar otra operación.
                $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
            } while ($Respuesta -eq 's ')
        }
        2 {
            # Consulta de usuario.
            $UsuarioDesbloquear = Read-Host "Ingresa el nombre de usuario"
            net user $UsuarioDesbloquear /domain
            $Respuesta = Read-Host "Quieres volver al menu principal? (s/n)"  
        }
        
        3 {
            # Actualizar el script remotamente.
            Write-Host "Actualizando el script remotamente..."

            # URL del repositorio central donde se encuentra la versión más reciente del script
            $ScriptRepoUrl = "https://raw.githubusercontent.com/wdelcant/ScriptsAdministration/main/Utilities.ps1"

            # Ruta local donde se guardará la versión actualizada del script
            $LocalScriptPath = Join-Path $ScriptDirectory ("Utilities_v$($version).ps1")

            # Descargar el script actualizado desde el repositorio
            Invoke-WebRequest -Uri $ScriptRepoUrl -OutFile $LocalScriptPath

            # Ejecutar el script actualizado
            Invoke-Expression -Command "& `"$LocalScriptPath`""

            # Salir del bucle principal después de actualizar el script
            Exit-PSHostProcess
        }
        4 {
            # Opción para salir del bucle principal.
            Exit-PSHostProcess
        }
        default {
            Write-Host "Opcion invalida"  -ForegroundColor Red
        }
    }
} while ($Respuesta -eq 's')
