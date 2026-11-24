#!/usr/bin/env bash
set -Eeuo pipefail

# Configurar gnome-terminal

# Ventana de terminal
PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ visible-name "$USER"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ font 'JetBrains Mono 12'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-columns 132
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-rows 43

# Modificaciones en .bashrc
BLOQUE="
# Configuraciones personales
# 'ls' a mi gusto
alias ls='ls -l --color=auto --all --time-style=long-iso'
"
echo "$BLOQUE" >> ~/.bashrc

