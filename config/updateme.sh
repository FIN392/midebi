#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Actualizar

sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y
sudo apt autoclean
sudo apt clean
sudo update-ca-certificates
