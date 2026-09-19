## ⚠️ AVISO IMPORTANTE

Este repositorio contiene las instrucciones de instalación y configuración para mi equipo de escritorio personal.

Si encuentras algo útil, genial.

---

## ℹ️ ¿Qué instalo?

- Debian con una partición EFI, una EXT4 para /boot, una BTRFS para / y otra de swap
- GNOME pero sin mucho del bloatware que incluye
- Tiling Shell (by domferr) para ajustar las ventanas
- Snapper para snapshots en BTRFS

---

## 📦 Instalación

Lanzar la ISO de Debian desde mi amado Ventoy.

Seleccionar *Graphical install* y seleccionar las siguientes opciones en las diferentes secciones de la instalación:

- Language: *Spanish - Español*
- País, territorio o área: *España*
- Mapa de teclado a usar: *Español*
<!-- --> 
- Interfaz de red primaria: *(LAN)*
<!-- -->
- Nombre de la máquina: *(Nombre del PC)*
- Nombre de dominio: *(vacio)*
- Clave del superusuario: *(vacio)*
- Nombre completo para el nuevo usuario: *(Nombre del usuario)*
- Nombre de usuario para la cuenta: *(ID de usuario)*
- Elija una contraseña para el nuevo usuario: *(Contraseña del usuario)* / *(Contraseña del usuario)*
- Seleccione una ubicación en su zona horaria: *Península*
<!-- -->
- Método de particionado: *Manual*
- Particionado de discos: *(Seleccionar disco a usar)*
- ¿Crear una nueva tabla de particiones vacía en este dispositivo?: *Si*

#### Definir 4 particiones
- *(Seleccionar 'ESPACIO LIBRE)*
- Cómo usar este espacio libre: *Crear una partición nueva*
- Nuevo tamaño de partición: *512 MB*
- Ubicación de la nueva partición: *Principio*
- Configuración de la partición:
  * Utilizar como: *Partición del sistema "EFI"*
  * Marca de arranque: *desactivada*
- *Se ha terminado de definir la partición*
<!-- -->
- *(Seleccionar 'ESPACIO LIBRE)*
- Cómo usar este espacio libre: *Crear una partición nueva*
- Nuevo tamaño de partición: *512 MB*
- Ubicación de la nueva partición: *Principio*
- Configuración de la partición:
  * Utilizar como: *sistema de ficheros ext4 transaccional*
  * Punto de montaje: */boot*
- *Se ha terminado de definir la partición*
<!-- -->
- *(Seleccionar 'ESPACIO LIBRE)*
- Cómo usar este espacio libre: *Crear una partición nueva*
- Nuevo tamaño de partición: *16 GB*
- Ubicación de la nueva partición: *Principio*
- Configuración de la partición:
  * Utilizar como: *área de intercambio*
- *Se ha terminado de definir la partición*
<!-- -->
- *(Seleccionar 'ESPACIO LIBRE)*
- Cómo usar este espacio libre: *Crear una partición nueva*
- Nuevo tamaño de partición: *(El total del disco)*
- Configuración de la partición:
  * Utilizar como: *sistema de ficheros btrfs transaccional*
- *Se ha terminado de definir la partición*

#### Resultado de las particiones
| Número |  Tamaño | Utilizar como | Punto de montaje |
| :----: | ------: | :------------ | :--------------- |
|   #1   |  512 MB | ESP           |                  |
|   #2   |  512 MB | ext4          | /boot            |
|   #3   |   16 GB | intercambio   | intercambio      |
|   #4   | 9999 GB | btrfs         | /                |

- *Finalizar el particionado y escribir los cambios en el disco*
- ¿Desea escribir los cambios en los discos?: *Si*
<!-- -->
- ¿Desea analizar medios de instalación adicionales?: *No*
- País de la réplica de Debian: *España*
- Réplica de Debian: *deb.debian.org*
- Información de proxy HTTP: *(vacio)*
<!-- -->
- Desea participar en la encuesta sobre el uso de los paquetes: *No*
<!-- -->
- Elegir los programas a instalar: *(Desmarcar TODO excepto '**Utilidades estándar del sistema**')*
<!-- -->
- Instalación completada

Se reiniciará el sistema en este punto.

---

## ⚙️ Configuración

Al inicia el sistema se mostrará la terminal, identificarse con el ID de usuario y contraseña, y ejecutar estos comandos:
```bash
sudo apt install git --no-install-recommends --no-install-suggests -y
git clone https://github.com/fin392/midebi
bash midebi/config/config.sh
```
---
