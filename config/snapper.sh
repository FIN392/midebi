#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Snapper

# Instalar
sudo apt install snapper -y

# Configurar
# Crear la configuración de Snapper para root y home
sudo snapper -c root create-config /
sudo snapper -c home create-config /home

# Ajustar la configuración (límites y timeline)
sudo snapper -c root set-config \
    TIMELINE_CREATE="yes" \
    TIMELINE_CLEANUP="yes" \
    TIMELINE_LIMIT_HOURLY="0" \
    TIMELINE_LIMIT_DAILY="3" \
    TIMELINE_LIMIT_WEEKLY="0" \
    TIMELINE_LIMIT_MONTHLY="0" \
    TIMELINE_LIMIT_YEARLY="0" \
    NUMBER_CLEANUP="yes" \
    NUMBER_LIMIT="5" \
    NUMBER_LIMIT_IMPORTANT="5"

# Ajustar la configuración (límites y timeline)
sudo snapper -c home set-config \
    TIMELINE_CREATE="yes" \
    TIMELINE_CLEANUP="yes" \
    TIMELINE_LIMIT_HOURLY="24" \
    TIMELINE_LIMIT_DAILY="7" \
    TIMELINE_LIMIT_WEEKLY="4" \
    TIMELINE_LIMIT_MONTHLY="12" \
    TIMELINE_LIMIT_YEARLY="1" \
    NUMBER_CLEANUP="yes" \
    NUMBER_LIMIT="5" \
    NUMBER_LIMIT_IMPORTANT="5"

# Crear un snapshot manual de prueba
sudo snapper -c root create --description "Snapshot inicial"
sudo snapper -c root list
sudo snapper -c home create --description "Snapshot inicial"
sudo snapper -c home list

# GUI para btrfs: btrfs-assistant
sudo apt install btrfs-assistant -y

# Snapshots en GRUB: grub-btrfs
cd ~
git clone https://github.com/Antynea/grub-btrfs.git
cd grub-btrfs
sudo make install
grub-mkconfig
sudo systemctl enable --now grub-btrfsd
sudo update-grub
