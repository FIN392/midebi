#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Desinstalar
echo -e "\e[36m*** Desinstalar ***\e[0m"
sudo apt purge "librewolf*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/librewolf/
rm -rf ~/.cache/librewolf/
sudo extrepo disable librewolf

# Instalar
echo -e "\e[36m*** Instalar ***\e[0m"
sudo apt install extrepo -y
sudo extrepo enable librewolf
sudo extrepo update librewolf
sudo apt update
sudo apt install librewolf -y

# Configurar
# echo -e "\e[36m*** Configurar ***\e[0m"
