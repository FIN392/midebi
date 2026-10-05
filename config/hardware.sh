#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Ajuster del hardware

# Gestión de Memoria y Swap (ZRAM)
sudo apt install zram-tools -y
sudo cat << 'EOF' | sudo tee /etc/default/zramswap > /dev/null
ALGO=zstd
PERCENT=50
PRIORITY=100
EOF
sudo systemctl restart zramswap
sudo cat << 'EOF' | sudo tee /etc/sysctl.d/99-performance.conf > /dev/null
vm.swappiness = 60
vm.vfs_cache_pressure = 50
EOF
sudo sysctl --system

# Optimización de Btrfs y Puntos de Montaje (/etc/fstab)
sudo apt install nvme-cli -y
awk '
  !/^#/ && $2 == "/" && $3 == "btrfs" {
    $4 = "defaults,noatime,compress=zstd:3,subvol=@rootfs"
  }
  { print }
' /etc/fstab > /tmp/fstab.tmp && sudo mv /tmp/fstab.tmp /etc/fstab
sudo mount -o remount /

# Rendimiento CPU 
sudo apt install power-profiles-daemon -y
powerprofilesctl set balanced

# Microcodigo de AMD
sudo apt install amd64-microcode -y

# Sensores
sudo apt install lm-sensors -y
sudo sensors-detect --auto
sensors
echo "nct6775" | sudo tee /etc/modules-load.d/nct6775.conf
sudo modprobe nct6775 || true 

