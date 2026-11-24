#!/usr/bin/env bash
set -Eeuo pipefail

# Optimizar hardware

# Gestión de Memoria y Swap (ZRAM)
sudo apt-get install zram-tools -y
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

# Instalación nvme-cli, microcodigo de AMD, sensores y power-profiles-daemon
sudo apt-get install -y \
  nvme-cli \
  amd64-microcode \
  lm-sensors \
  power-profiles-daemon

# Rendimiento CPU
powerprofilesctl set balanced || true

read -r -p "1 Pulsa Enter para continuar..."

# Sensores
sudo sensors-detect --auto

read -r -p "2 Pulsa Enter para continuar..."

sensors || true

read -r -p "3 Pulsa Enter para continuar..."

echo "nct6775" | sudo tee /etc/modules-load.d/nct6775.conf

read -r -p "4 Pulsa Enter para continuar..."

sudo modprobe nct6775 || true 

read -r -p "5 Pulsa Enter para continuar..."

