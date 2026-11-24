#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar font JetBrains
print_section "INSTALANDO FUENTES JETBRAINS MONO"
sudo apt install fonts-jetbrains-mono -y
fc-cache -f
