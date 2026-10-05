#!/usr/bin/env bash
set -Eeuo pipefail

# === MANEJO DE ERRORES ===
error_handler() {
  local rc=$?
  local line=$1
  local command=$2
  echo -e "\e[31m========================================" >&2
  echo "  ERROR" >&2
  echo "  Línea: $line" >&2
  echo "  Comando: $command" >&2
  echo "  Código de salida: $rc" >&2
  echo "  Directorio: $(pwd)" >&2
  echo "  Usuario: $(whoami)" >&2
  echo -e "========================================\e[0m" >&2
  exit "$rc"
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# === FUNCIONES ===
print_section() {
  echo -e "\e[36m========================================\e[0m"
  echo -e "\e[36m  $1\e[0m"
  echo -e "\e[36m========================================\e[0m"
}

# === MAIN ===

# Directorio actual
DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Evitar la instalación de paquetes recomendados y sugeridos
print_section "CONFIGURANDO APT"
echo "APT::Install-Recommends \"false\";" | sudo tee /etc/apt/apt.conf.d/98norecommends
echo "APT::Install-Suggests   \"false\";" | sudo tee /etc/apt/apt.conf.d/99nosuggests

# Actualizar
print_section "ACTUALIZANDO EL SISTEMA"
bash "$DIR_ACTUAL/updateme.sh"

# Install GNOME con GDM3
print_section "INSTALANDO GNOME"
sudo apt install -y \
  xserver-xorg-core \
  xinit \
  gnome-core
sudo systemctl set-default graphical.target

# Eliminar software
print_section "ELIMINANDO SOFTWARE INNECESARIO"
sudo apt purge -y \
  gnome-software \
  gnome-tour \
  gnome-calendar \
  gnome-characters \
  gnome-contacts \
  gnome-weather \
  gnome-maps \
  gnome-clocks \
  gnome-connections \
  gnome-font-viewer \
  gnome-disk-utility \
  totem \
  simple-scan \
  loupe
sudo apt autoremove --purge -y
sudo apt autoclean 
sudo apt clean

# Firewall
print_section "CONFIGURANDO FIREWALL"
NFT_CONF="/etc/nftables.conf"
sudo cat << 'EOF' | sudo tee /etc/nftables.conf > /dev/null
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;
        # Permitir tráfico interno del sistema (loopback)
        iifname "lo" accept
        # Permitir respuestas a respuestas/conexiones iniciadas por ti
        ct state established,related accept
        # (Opcional) Permitir ICMP (ping)
        ip protocol icmp accept
    }
    chain forward {
        type filter hook forward priority filter; policy drop;
    }
    chain output {
        type filter hook output priority filter; policy accept;
    }
}
EOF
sudo chmod 755 "$NFT_CONF"
sudo systemctl enable --now nftables

# Optimización de hardware
print_section "OPTIMIZACIONES HARDWARE"
bash "$DIR_ACTUAL/hardware.sh"

# Instalar herramientas básicas
print_section "INSTALANDO HERRAMIENTAS"
sudo apt install -y \
  dconf-editor \
  curl \
  jq \
  gparted \
  htop

# Eliminar directorios innecesarios
print_section "ELIMINANDO DIRECTORIOS INNECESARIOS"
sudo cat << 'EOF' | sudo tee /etc/xdg/user-dirs.defaults > /dev/null
# Default settings for user directories
#
# The values are relative pathnames from the home directory and
# will be translated on a per-path-element basis into the users locale
DESKTOP=Desktop
DOWNLOAD=Downloads
#TEMPLATES=Templates
#PUBLICSHARE=Public
DOCUMENTS=Documents
#MUSIC=Music
#PICTURES=Pictures
#VIDEOS=Videos
# Another alternative is:
#MUSIC=Documents/Music
#PICTURES=Documents/Pictures
#VIDEOS=Documents/Videos
EOF

# Instalar JetBrains font
print_section "INSTALANDO FUENTES JETBRAINS MONO"
sudo apt install fonts-jetbrains-mono -y
fc-cache -f

# Configurar gnome-terminal
print_section "CONFIGURANDO TERMINAL"
bash "$DIR_ACTUAL/terminalconfig.sh"

# Configurar escritorio
print_section "CONFIGURANDO ESCRITORIO"
bash "$DIR_ACTUAL/gnomeconfig.sh"

# Instalar y configurar Tiling Shell
print_section "INSTALANDO TILING SHELL"
bash "$DIR_ACTUAL/tilingshell.sh"

# Instalar y configura Snapper
print_section "INSTALANDO SNAPPER"
FSTYPE=$(findmnt -n -o FSTYPE /)
if [ "$FSTYPE" = "btrfs" ]; then
  bash "$DIR_ACTUAL/snapper.sh"
else
    echo -e "\e[33m\u26a0 No se instala Snapper. La partición / no usa Btrfs (formato detectado: $FSTYPE).\e[0m"
    sleep 3
fi

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
