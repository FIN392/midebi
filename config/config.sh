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
SECTIONS=13

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
run_section "5/$SECTIONS: OPTIMIZAR HARDWARE (20s)" "$DIR_ACTUAL/hardware.sh"
sensors || true
echo "Power profile: $(powerprofilesctl get)"

# Instalar herramientas básicas
run_section "6/$SECTIONS: INSTALAR HERRAMIENTAS (60s)" "$DIR_ACTUAL/tools.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' dconf-editor curl jq gparted htop make

# Instalar font JetBrains
run_section "7/$SECTIONS: INSTALAR FUENTES (5s)" "$DIR_ACTUAL/fonts.sh"
fc-list | grep -i "JetBrains Mono:"

# Instalar GNOME con GDM3 y eliminar software innecesario
run_section "8/$SECTIONS: INSTALAR GNOME (10m 30s)" "$DIR_ACTUAL/gnomeinstall.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' gdm3 gnome* | grep -i "install ok"

read -r -p "Pulsa Enter para continuar..."

# Configurar GNOME
run_section "9/$SECTIONS: CONFIGURAR GNOME (ns)" "$DIR_ACTUAL/gnomeconfig.sh"
gsettings get org.gnome.shell enabled-extensions

read -r -p "Pulsa Enter para continuar..."

# Instalar Clipboard Indicator
run_section "10/$SECTIONS: INSTALAR CLIPBOARD INDICATOR (ns)" "$DIR_ACTUAL/clipboard.sh"
gsettings get org.gnome.shell enabled-extensions

read -r -p "Pulsa Enter para continuar..."

# Configurar usuario
run_section "11/$SECTIONS: CONFIGURAR USUARIO (ns)" "$DIR_ACTUAL/userconfig.sh"
cat /etc/xdg/user-dirs.defaults

read -r -p "Pulsa Enter para continuar..."

# Instalar Tiling Shell
run_section "12$SECTIONS: INSTALAR TILING SHELL (ns)" "$DIR_ACTUAL/tilingshell.sh"
gsettings get org.gnome.shell enabled-extensions

read -r -p "Pulsa Enter para continuar..."

# Instalar Snapper, btrfs-assistant y grub-btrfs
run_section "13/$SECTIONS: INSTALAR SNAPPER (30s)" "$DIR_ACTUAL/snapper.sh"
dpkg-query -W -f='${Status}\t${Package}\t${Version}\n' snapper btrfs-assistant
sudo snapper list-configs

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
