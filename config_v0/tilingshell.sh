#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Tiling Shell

# Instalar
curl -L -o /tmp/tilingshell.zip "https://github.com/domferr/tilingshell/releases/download/17.3/tilingshell@ferrarodomenico.com.zip"
gnome-extensions install --force /tmp/tilingshell.zip
gnome-extensions enable tilingshell@ferrarodomenico.com
rm --force /tmp/tilingshell.zip

# Configurar
SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com/schemas"
LAYOUTS_JSON='[
  {"id": "2 Columnas (50/50)", "tiles": [{"x": 0, "y": 0, "width": 0.5, "height": 1}, {"x": 0.5, "y": 0, "width": 0.5, "height": 1}]},
  {"id": "2 Filas (50/50)", "tiles": [{"x": 0, "y": 0, "width": 1, "height": 0.5}, {"x": 0, "y": 0.5, "width": 1, "height": 0.5}]},
  {"id": "4 Esquinas (2x2)", "tiles": [{"x": 0, "y": 0, "width": 0.5, "height": 0.5}, {"x": 0.5, "y": 0, "width": 0.5, "height": 0.5}, {"x": 0, "y": 0.5, "width": 0.5, "height": 0.5}, {"x": 0.5, "y": 0.5, "width": 0.5, "height": 0.5}]}
]'
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.tilingshell layouts-json "$LAYOUTS_JSON"
