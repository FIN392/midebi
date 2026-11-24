#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar Clipboard Indicator
git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
mkdir -p ~/.local/share/glib-2.0/schemas
cp ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/*.xml ~/.local/share/glib-2.0/schemas/
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gnome-extensions enable clipboard-indicgnomeator@tudmotu.com
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']"
gsettings set org.gnome.shell.extensions.clipboard-indicator history-size 50
gsettings set org.gnome.shell.extensions.clipboard-indicator display-mode 0
gsettings set org.gnome.shell.extensions.clipboard-indicator notify-on-copy false
gsettings set org.gnome.shell.extensions.clipboard-indicator clear-on-boot false
gsettings set org.gnome.shell.extensions.clipboard-indicator paste-on-select true
