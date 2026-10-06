#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación
# DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Desinstalar
echo -e "\e[36m*** Desinstalar ***\e[0m"
sudo apt purge "fastfetch*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/fastfetch/
rm -rf ~/.cache/fastfetch/

# Instalar
echo -e "\e[36m*** Instalar ***\e[0m"
sudo apt install fastfetch -y

# Configurar
echo -e "\e[36m*** Configurar ***\e[0m"
fastfetch --gen-config
sudo cat << 'EOF' | sudo tee "$HOME/.config/fastfetch/config.jsonc" > /dev/null
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "padding": { "top": 3, "left": 1 },
        "color": { "1": "red", "2": "red" }
    },
    "modules": [
        "break",
        { "type": "custom", "format": "\u001b[90m--- Hardware ---------------------------" },
        { "type": "host", "key": " Host ", "keyColor": "green" },
        { "type": "cpu", "key": " CPU ", "keyColor": "green", "showPeCoreCount": true, "temp": true },
        { "type": "gpu", "key": " GPU ", "keyColor": "green" },
        { "type": "memory", "key": " Memory ", "keyColor": "green" },
        { "type": "swap", "key": " Swap ", "keyColor": "green" },
        { "type": "disk", "key": " Disk ", "keyColor": "green" },
        { "type": "display", "key": " Display ", "keyColor": "green" },
        { "type": "sound", "key": " Sound ", "keyColor": "green" },
        { "type": "custom", "format": "\u001b[90m----------------------------------------" },
        "break",
        { "type": "custom", "format": "\u001b[90m--- Software ---------------------------" },
        { "type": "bios", "key": " BIOS ", "keyColor": "yellow" },
        { "type": "os", "key": " OS ", "keyColor": "yellow" },
        { "type": "kernel", "key": " Kernel ", "keyColor": "yellow" },
        { "type": "shell", "key": " Shell ", "keyColor": "yellow" },
        { "type": "de", "key": " Desktop Environment ", "keyColor": "yellow" },
        { "type": "lm", "key": " Login Manager ", "keyColor": "yellow" },
        { "type": "wm", "key": " Windows Manager ", "keyColor": "yellow" },
        { "type": "wmtheme", "key": " Windows Manager Theme ", "keyColor": "yellow" },
        { "type": "terminal", "key": " Terminal ", "keyColor": "yellow" },
        { "type": "packages", "key": " Packages ", "keyColor": "yellow" },
        { "type": "custom", "format": "\u001b[90m----------------------------------------" },
        "break",
        { "type": "custom", "format": "\u001b[90m--- Uptime------------------------------" },
        { "type": "command", "key": " OS Age ", "keyColor": "magenta", "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days" },
        { "type": "uptime", "key": " Uptime ", "keyColor": "magenta" },
        { "type": "datetime", "key": " Date and time ", "keyColor": "magenta" },
        { "type": "custom", "format": "\u001b[90m----------------------------------------" },
        { "type": "colors", "paddingLeft": 2, "symbol": "circle" }
    ]
}
EOF
