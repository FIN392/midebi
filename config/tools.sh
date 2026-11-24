#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar herramientas básicas
sudo apt-get install -y \
  dconf-editor \
  curl \
  jq \
  gparted \
  htop \
  make
  