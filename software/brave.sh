#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Brave Origin
# DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Desinstalar
echo -e "\e[36m*** Desinstalar ***\e[0m"
sudo apt purge "brave*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/BraveSoftware/

# Instalar
echo -e "\e[36m*** Instalar ***\e[0m"
curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh

# Configurar
echo -e "\e[36m*** Configurar ***\e[0m"
mkdir -p "$HOME/.config/BraveSoftware/Brave-Origin/Default"
sudo cat << 'EOF' | sudo tee "$HOME/.config/BraveSoftware/Brave-Origin/Default/Preferences" > /dev/null
{
  "bookmark_bar": { "show_on_all_tabs": false },
  "brave": {
    "tabs": { "vertical_tabs_enabled": true },
    "always_show_bookmark_bar_on_ntp": false,
    "new_tab_page": {
      "show_background_image": true,
      "background": {
        "random": false,
        "selected_value": "#000000",
        "type": "color"
      },
      "hide_all_widgets": true,
      "show_brave_news": false,
      "show_stats": false,
      "show_rewards": false
    }
  },
  "ntp": {
    "custom_background_inspiration": false,
    "custom_background_local_to_device": false,
    "shortcust_visible": false
  }
}
EOF
