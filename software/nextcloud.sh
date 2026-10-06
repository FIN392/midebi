#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación
# DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Desinstalar
echo -e "\e[36m*** Desinstalar ***\e[0m"
sudo apt purge "nextcloud-desktop*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/Nextcloud/
rm -rf ~/.cache/Nextcloud/

# Instalar
echo -e "\e[36m*** Instalar ***\e[0m"
sudo apt install nextcloud-desktop -y

# Configurar
# echo -e "\e[36m*** Configurar ***\e[0m"
