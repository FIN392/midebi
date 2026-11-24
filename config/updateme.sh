#!/usr/bin/env bash
set -Eeuo pipefail

# Actualizar

sudo apt-get update
sudo apt-get full-upgrade -y
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
sudo apt-get clean
sudo update-ca-certificates
