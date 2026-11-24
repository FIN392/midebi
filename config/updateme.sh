#!/usr/bin/env bash
set -Eeuo pipefail

# Actualizar

sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y
sudo apt autoclean
sudo apt clean
sudo update-ca-certificates
