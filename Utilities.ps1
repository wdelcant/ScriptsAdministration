    # Author: Wilson Del Canto
    # Cencosud S.A
    # Date: 2023-11-11
    # Version: 1.2 alpha

    # Este script proporciona una interfaz para realizar operaciones remotas en equipos Windows.

    # Definir tiempo de espera predeterminado para operaciones remotas (en segundos).
    $TiempoEsperaPredeterminado = 60

    # Obtener la ruta del directorio del script
    $ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

    # Construir la ruta del archivo de registro en el mismo directorio que el script
    $LogFile = Join-Path $ScriptDirectory "Log.txt"

    # Limpia la consola al inicio del script.
    Clear-Host

    # Presenta información sobre la versión y la fecha.
    Write-Host "Bienvenido al programa de operaciones remotas." -ForegroundColor Blue
    Write-Host "# Version: 1.2 alpha" -ForegroundColor Green
    Write-Host "# Date: 2023-11-10`n`n" -ForegroundColor Green

    # Manejo de errores
    trap {
        Write-Host "Error: $_" -ForegroundColor Red
        Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ERROR: $_"
        continue
    }

    # Inicio del bucle principal del programa.
    do {
        # Menú principal que permite seleccionar entre diferentes opciones.
        $OpcionPrincipal = Read-Host "Que deseas hacer?`n`n1. Realizar operaciones en equipo remoto`n2. Consulta usuario dominio`n3. Activar Office365`n4. Update (test)`n5. Salir`n`nSelecciona la opción"

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
                    $Opcion = Read-Host "Que accion deseas realizar?`n`n1. Obtener serie`n2. Reiniciar PC`n3. Apagar PC`n4. Obtener información del sistema operativo`n5. Listar procesos en ejecución`n6. Cerrar programa`n7. Desinstalar programa (sin probar)`n8. Consultar usuarios en PC`n9. Configuración de red`n10. Listar programas instalados`n11. Configurar red`n12. Salir`n`nSelecciona la opción"

                    # Switch para manejar las diferentes operaciones remotas.
                    switch ($Opcion) {
                        1 {
                            # Obtener el número de serie del equipo.
                            $InicioOperacion = [DateTime]::Now
                            Clear-Host
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password bios get serialnumber
                        }
                        2 {
                            # Reiniciar el equipo remoto.
                            $InicioOperacion = [DateTime]::Now
                            Clear-Host
                            Write-Host "Reiniciando el equipo remoto. Esto puede tomar un tiempo..."
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password process call create "shutdown /r /t $TiempoEsperaPredeterminado /f"
                        }
                        3 {
                            # Apagar el equipo remoto.
                            Clear-Host
                            Write-Host "Apagando el equipo remoto. Esto puede tomar un tiempo..."
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password process call create "shutdown /s /t $TiempoEsperaPredeterminado /f"
                        }
                        4 {
                            # Obtener información del sistema del equipo remoto.
                            Clear-Host
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password os get caption,version,serialnumber
                        }
                        5 {
                            # Listar procesos en ejecución en el equipo remoto.
                            Clear-Host
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password process list brief
                        }
                        6 {
                            # Cerrar un programa específico en el equipo remoto.
                            Clear-Host
                            $Programa = Read-Host "Ingresa el nombre del programa a cerrar"
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password process where "name like '%$Programa%'" call terminate
                        }
                        7 {
                            # Desinstalar un programa específico en el equipo remoto.
                            Clear-Host
                            $Programa = Read-Host "Ingresa el nombre del programa a desinstalar"
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password product where "name like '%$Programa%'" call uninstall
                        }
                        8 {
                            # Consultar usuarios en el equipo remoto.
                            Clear-Host
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password useraccount list brief
                        }
                        9 {
                            # Configuración de red en el equipo remoto.
                            Clear-Host
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
                            Clear-Host
                            wmic /node:$Nombrepc /user:$Usuario /password:$Password product get name,version
                        }
                        11 {
                            # Configuración adicional de red en el equipo remoto.
                            Clear-Host
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
                        12 {
                            # Opción para salir del bucle interno.
                            Exit-PSHostProcess
                        }
                        default {
                            Write-Host "Opcion invalida"  -ForegroundColor Red
                        }
                    }

                    # Registro de actividad
                    Add-Content -Path $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Operación: $Opcion en $Nombrepc por $Usuario - Duración: $([DateTime]::Now - $InicioOperacion)"
                    
                    # Pregunta al usuario si desea realizar otra operación.
                    $Respuesta = Read-Host "Quieres realizar otra operacion? (s/n)"
                } while ($Respuesta -eq 's')
            }
            2 {
                # Consulta de usuario.
                Clear-Host
                $UsuarioDesbloquear = Read-Host "Ingresa el nombre de usuario"
                net user $UsuarioDesbloquear /domain
                $Respuesta = Read-Host "Quieres volver al menú principal? (s/n)"  
            }
            3 {
                # Activar Office 365
                Clear-Host
                Write-Host "Activando Office 365..."
                gpupdate /force /Sync
                powershell -Command "Enable-ScheduledTask -TaskPath '\Microsoft\Windows\Workplace Join' -TaskName Automatic-Device-Join"
                powershell -Command "Start-ScheduledTask -TaskPath '\Microsoft\Windows\Workplace Join' -TaskName Automatic-Device-Join"
                dsregcmd /Debug /join
                Write-Host "Office 365 activado con éxito." -ForegroundColor Green
                $Respuesta = Read-Host "Quieres volver al menú principal? (s/n)"
            }
            4 {
                # Actualizar el script remotamente.
                Clear-Host
                Write-Host "Actualizando el script remotamente..."

                # URL del repositorio central donde se encuentra la versión más reciente del script
                $ScriptRepoUrl = "https://tu-repositorio/scripts/AdminScript.ps1"

                # Ruta local donde se guardará la versión actualizada del script
                $LocalScriptPath = Join-Path $ScriptDirectory "AdminScriptUpdated.ps1"

                # Descargar el script actualizado desde el repositorio
                Invoke-WebRequest -Uri $ScriptRepoUrl -OutFile $LocalScriptPath

                # Ejecutar el script actualizado
                Invoke-Expression -Command "& `"$LocalScriptPath`""

                # Salir del bucle principal después de actualizar el script
                $Respuesta = 'n'
            }
            5 {
                # Opción para salir del bucle principal.
                Exit-PSHostProcess
            }
            default {
                Write-Host "Opcion invalida"  -ForegroundColor Red
            }
        }
    } while ($Respuesta -eq 's')
