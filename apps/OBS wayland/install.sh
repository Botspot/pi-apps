#!/usr/bin/env bash
set -euo pipefail

# Root-Check
if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "Installiere obs-plugins..."
$SUDO apt-get update
$SUDO apt-get install -y obs-plugins

echo "Fertig! obs-plugins wurden installiert."
