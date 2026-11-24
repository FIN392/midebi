#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar herramientas básicas
sudo apt install -y \
  dconf-editor \
  curl \
  jq \
  gparted \
  htop \
  make
  