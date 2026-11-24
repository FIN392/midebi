#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar GNOME con GDM3
sudo apt-get install -y \
  gdm3 \
  gnome-core
sudo systemctl set-default graphical.target

# Eliminar aplicaciones de GNOME que no se necesitan
sudo apt-get purge -y \
  gnome-software \
  gnome-tour \
  gnome-calendar \
  gnome-characters \
  gnome-contacts \
  gnome-weather \
  gnome-maps \
  gnome-clocks \
  gnome-connections \
  gnome-font-viewer \
  gnome-disk-utility \
  totem \
  simple-scan \
  evince \
  loupe
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
