#!/usr/bin/env bash
set -Eeuo pipefail

# Configurar usuario

# Modificaciones en .bashrc
BLOQUE="
# Configuraciones personales
# 'ls' a mi gusto
alias ls='ls -l --color=auto --all --time-style=long-iso'
"
echo "$BLOQUE" >> ~/.bashrc

# Eliminar directorios innecesarios
print_section "ELIMINANDO DIRECTORIOS INNECESARIOS"
sudo cat << 'EOF' | sudo tee /etc/xdg/user-dirs.defaults > /dev/null
# Default settings for user directories
#
# The values are relative pathnames from the home directory and
# will be translated on a per-path-element basis into the users locale
DESKTOP=Desktop
DOWNLOAD=Downloads
#TEMPLATES=Templates
#PUBLICSHARE=Public
DOCUMENTS=Documents
#MUSIC=Music
#PICTURES=Pictures
#VIDEOS=Videos
# Another alternative is:
#MUSIC=Documents/Music
#PICTURES=Documents/Pictures
#VIDEOS=Documents/Videos
EOF
