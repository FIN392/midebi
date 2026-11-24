#!/usr/bin/env bash
set -Eeuo pipefail

# Crear subvolúmenes Btrfs: @rootfs, @home y @vms

# Separar /home y /VMs en subvolúmenes Btrfs independientes de /
BDEV=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
BTRFS_UUID=$(findmnt -n -o UUID /)
BTRFS_MOUNT="/mnt/btrfs-root"
# crear puntos de montaje
sudo mkdir -p "$BTRFS_MOUNT" /home /VMs
# Montar el nivel superior de Btrfs (subvolid=5)
sudo mount -o subvolid=5 "$BDEV" "$BTRFS_MOUNT"
# Crear subvolúmenes
sudo btrfs subvolume create "$BTRFS_MOUNT/@home"
sudo btrfs subvolume create "$BTRFS_MOUNT/@vms"
sudo chattr +C "$BTRFS_MOUNT/@vms"
# Copiar contenido existente
sudo cp --reflink=always -a /home/. "$BTRFS_MOUNT/@home/"
sudo cp --reflink=always -a /VMs/. "$BTRFS_MOUNT/@vms/"
# Limpiar directorios originales de @rootfs
sudo rm -rf "$BTRFS_MOUNT/@rootfs/home/"*
sudo rm -rf "$BTRFS_MOUNT/@rootfs/home/".[!.]*
sudo rm -rf "$BTRFS_MOUNT/@rootfs/home/"..?*
sudo rm -rf "$BTRFS_MOUNT/@rootfs/VMs/"*
sudo rm -rf "$BTRFS_MOUNT/@rootfs/VMs/".[!.]*
sudo rm -rf "$BTRFS_MOUNT/@rootfs/VMs/"..?*
# Eliminar los directorios originales antes de montar los subvolúmenes
sudo rmdir "$BTRFS_MOUNT/@rootfs/home"
sudo rmdir "$BTRFS_MOUNT/@rootfs/VMs"
# Recrear puntos de montaje
sudo mkdir -p /home /VMs
# Registrar los nuevos montajes en /etc/fstab
echo "UUID=$BTRFS_UUID  /home  btrfs  defaults,noatime,compress=zstd:3,subvol=@home  0  0" |
    sudo tee -a /etc/fstab >/dev/null
echo "UUID=$BTRFS_UUID  /VMs   btrfs  defaults,noatime,compress=zstd:3,subvol=@vms   0  0" |
    sudo tee -a /etc/fstab >/dev/null
# Montar los nuevos subvolúmenes
sudo systemctl daemon-reload
sudo mount /home
sudo mount /VMs
# Desmontar y limpiar el punto de montaje temporal
sudo umount "$BTRFS_MOUNT"
sudo rmdir "$BTRFS_MOUNT"
