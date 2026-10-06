#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Desinstalar
echo -e "\e[36m*** Desinstalar ***\e[0m"
sudo apt purge "obsidian*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/obsidian/
rm -rf ~/.cache/obsidian/

# Instalar
echo -e "\e[36m*** Instalar ***\e[0m"
wget -P /tmp https://github.com/obsidianmd/obsidian-releases/releases/download/v1.14.4/obsidian_1.14.4_amd64.deb
sudo apt install /tmp/obsidian_1.14.4_amd64.deb

# Configurar
# echo -e "\e[36m*** Configurar ***\e[0m"
