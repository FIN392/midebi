#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Configurar escritorio

# Fuente por defecto
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 12'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 12'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 12'

# Modo oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Fondo negro
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'

# Reloj superior con fecha y 24h
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true

# Botones en ventanas
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Quitar aplicaciones del tablero
gsettings set org.gnome.shell favorite-apps "[]"

# Ordenar la cuadrícula de aplicaciones
gsettings set org.gnome.desktop.app-folders folder-children "['']"
gsettings reset org.gnome.shell app-picker-layout

# Iconos en escritorio
sudo apt install gnome-shell-extension-desktop-icons-ng -y
gsettings set org.gnome.shell.extensions.ding show-volumes true
gsettings set org.gnome.shell.extensions.ding show-trash false
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding show-network-volumes true
gnome-extensions enable ding@rastersoft.com

# Dash to dock
sudo apt install gnome-shell-extension-dashtodock -y
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gnome-extensions enable dash-to-dock@micxgx.gmail.com

# Clipboard indicator
git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
mkdir -p ~/.local/share/glib-2.0/schemas
cp ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/*.xml ~/.local/share/glib-2.0/schemas/
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gnome-extensions enable clipboard-indicator@tudmotu.com
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']"
gsettings set org.gnome.shell.extensions.clipboard-indicator history-size 50
gsettings set org.gnome.shell.extensions.clipboard-indicator display-mode 0
gsettings set org.gnome.shell.extensions.clipboard-indicator notify-on-copy false
gsettings set org.gnome.shell.extensions.clipboard-indicator clear-on-boot false
gsettings set org.gnome.shell.extensions.clipboard-indicator paste-on-select true
