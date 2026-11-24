#!/usr/bin/env bash
set -Eeuo pipefail

# Evitar la instalación de paquetes recomendados y sugeridos
echo "APT::Install-Recommends \"false\";" | sudo tee /etc/apt/apt.conf.d/98norecommends
echo "APT::Install-Suggests   \"false\";" | sudo tee /etc/apt/apt.conf.d/99nosuggests
