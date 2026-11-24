#!/usr/bin/env bash
set -Eeuo pipefail

# Instalar font JetBrains
sudo apt-get install fonts-jetbrains-mono -y
fc-cache -f
