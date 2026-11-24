#!/usr/bin/env bash
set -Eeuo pipefail

# === FUNCIONES ===
print_section() {
  echo -e "\e[36m========================================\e[0m"
  echo -e "\e[36m  $1\e[0m"
  echo -e "\e[36m========================================\e[0m"
  { echo; printf '%0.s*' {1..80}; echo; } >> "$LOG_FILE"
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1\n" >> "$LOG_FILE"
}

run_section() {
  print_section "$1"
  {
    bash "$2" 2> >( tee -a "$LOG_FILE" >&2 )
  } >> "$LOG_FILE"
}

# === MAIN ===

# Variables
DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME=$(basename -- "${BASH_SOURCE[0]}")
LOG_FILE="$DIR_ACTUAL/${SCRIPT_NAME%.*}.log"
SECTIONS=9

# Evitar la instalación de paquetes recomendados y sugeridos
run_section "1/$SECTIONS: CONFIGURAR APT (1s)" "$DIR_ACTUAL/aptconfig.sh"
apt-config dump | grep -i '^APT::Install'

# Actualizar
run_section "2/$SECTIONS: ACTUALIZAR EL SISTEMA (3s)" "$DIR_ACTUAL/updateme.sh"
sudo apt -s full-upgrade

# Crear subvolúmenes Btrfs: @rootfs, @home y @vms
run_section "3/$SECTIONS: CREAR SUBVOLUMENES BTRFS (1s)" "$DIR_ACTUAL/btrfssubvols.sh"
sudo btrfs subvolume list / | grep -i 'level 5'

# Configurar firewall
run_section "4/$SECTIONS: CONFIGURAR FIREWALL (1s)" "$DIR_ACTUAL/firewall.sh"
echo
sudo nft list ruleset

# Optimizar hardware
run_section "5/$SECTIONS: OPTIMIZAR HARDWARE (50s)" "$DIR_ACTUAL/hardware.sh"
sensors || true
echo "Power profile: $(powerprofilesctl get)"

# Instalar herramientas básicas
run_section "6/$SECTIONS: INSTALAR HERRAMIENTAS (50s)" "$DIR_ACTUAL/tools.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' dconf-editor curl jq gparted htop make

# Instalar font JetBrains
run_section "7/$SECTIONS: INSTALAR FUENTES (ns)" "$DIR_ACTUAL/fonts.sh"
fc-list | grep -i "JetBrains Mono:"

# Instalar GNOME con GDM3 y eliminar software innecesario
run_section "8/$SECTIONS: INSTALAR GNOME (ns)" "$DIR_ACTUAL/gnomeinstall.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' gdm3 gnome* | grep -i "install ok"

read -r -p "Pulsa Enter para continuar..."

# Instalar Snapper, btrfs-assistant y grub-btrfs
run_section "9/$SECTIONS: INSTALAR SNAPPER" "$DIR_ACTUAL/snapper.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' snapper btrfs-assistant
sudo snapper list-configs

read -r -p "Pulsa Enter para continuar..."

# Reboot
print_section "FIN DE LA CONFIGURACION"
read -e -p $'\e[33m\u26a0 ¿Deseas reiniciar el sistema ahora? (s/N): \e[0m' respuesta
case "$respuesta" in
    [sS]|[sS][iI]|[yY]|[yY][eE][sS])
        sudo reboot
        ;;
    *)
        echo -e "\e[36m\u2139 Configuración finalizada.\e[0m"
        ;;
esac



# # Eliminar directorios innecesarios
# print_section "ELIMINANDO DIRECTORIOS INNECESARIOS"
# sudo cat << 'EOF' | sudo tee /etc/xdg/user-dirs.defaults > /dev/null
# # Default settings for user directories
# #
# # The values are relative pathnames from the home directory and
# # will be translated on a per-path-element basis into the users locale
# DESKTOP=Desktop
# DOWNLOAD=Downloads
# #TEMPLATES=Templates
# #PUBLICSHARE=Public
# DOCUMENTS=Documents
# #MUSIC=Music
# #PICTURES=Pictures
# #VIDEOS=Videos
# # Another alternative is:
# #MUSIC=Documents/Music
# #PICTURES=Documents/Pictures
# #VIDEOS=Documents/Videos
# EOF



# # Configurar gnome-terminal
# print_section "CONFIGURANDO TERMINAL"
# bash "$DIR_ACTUAL/terminalconfig.sh"

# # Configurar escritorio
# print_section "CONFIGURANDO ESCRITORIO"
# bash "$DIR_ACTUAL/gnomeconfig.sh"

# # Instalar y configurar Tiling Shell
# print_section "INSTALANDO TILING SHELL"
# bash "$DIR_ACTUAL/tilingshell.sh"

