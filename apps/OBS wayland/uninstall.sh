#!/usr/bin/env bash
set -euo pipefail

# Root-Check
if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "Deinstalliere obs-plugins..."
$SUDO apt-get remove -y obs-plugins

echo "obs-plugins wurden erfolgreich deinstalliert."
